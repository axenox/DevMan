<?php
namespace axenox\DevMan\Facades\WebhookFacade\Middleware;

use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\StreamFactoryInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

/**
 * Alternative implementation from Microsoft Copilot
 */
class AzureDevOpsPushToGitHubFormatMiddleware implements MiddlewareInterface
{
    public function __construct(
        private readonly StreamFactoryInterface $streamFactory,
        private readonly string $originalKey = '_original'
    ) {}

    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $raw = $this->readBody($request);
        if ($raw === '') {
            return $handler->handle($request);
        }

        $data = json_decode($raw, true);
        if (!is_array($data)) {
            return $handler->handle($request);
        }

        if (!$this->isAzureDevOpsGitPush($data)) {
            return $handler->handle($request);
        }

        $translated = $this->translateAzureDevOpsGitPushToTargetPushSchema($data, $raw);

        $json = json_encode(
            $translated,
            JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE
        );

        // If encoding fails, don't break the pipeline – pass through unchanged.
        if (!is_string($json)) {
            return $handler->handle($request);
        }

        $newBody = $this->streamFactory->createStream($json);

        $request = $request
            ->withBody($newBody)
            ->withHeader('Content-Type', 'application/json')
            ->withHeader('X-Webhook-Translated-From', 'azure-devops')
            ->withAttribute('azureDevOps.original', $data);

        return $handler->handle($request);
    }

    private function isAzureDevOpsGitPush(array $data): bool
    {
        // Canonical indicator for service hooks push payloads
        if (($data['eventType'] ?? null) === 'git.push') {
            return true;
        }

        // Secondary hints
        if (($data['publisherId'] ?? null) === 'tfs' && isset($data['resource']['refUpdates'], $data['resource']['commits'])) {
            return true;
        }

        return false;
    }

    private function translateAzureDevOpsGitPushToTargetPushSchema(array $ado, string $rawOriginal): array
    {
        $resource   = $ado['resource'] ?? [];
        $repo       = $resource['repository'] ?? [];
        $project    = $repo['project'] ?? [];
        $pushedBy   = $resource['pushedBy'] ?? [];

        $refUpdate  = $resource['refUpdates'][0] ?? [];
        $before     = $refUpdate['oldObjectId'] ?? null;
        $after      = $refUpdate['newObjectId'] ?? null;
        $ref        = $refUpdate['name'] ?? null;

        $remoteUrl  = $repo['remoteUrl'] ?? ($repo['url'] ?? null);
        $defaultRef = $repo['defaultBranch'] ?? null;

        $userName   = $pushedBy['displayName'] ?? null;
        $userEmail  = $pushedBy['uniqueName'] ?? null;
        $userId     = $pushedBy['id'] ?? null;
        $userUsername = $this->guessUsername($userEmail, $userName);

        $commitsIn  = is_array($resource['commits'] ?? null) ? $resource['commits'] : [];
        $commitsOut = [];

        foreach ($commitsIn as $c) {
            if (!is_array($c)) {
                continue;
            }

            $message  = (string)($c['comment'] ?? '');
            $title    = $this->firstLine($message);
            $ts       = $c['author']['date'] ?? ($c['committer']['date'] ?? null);

            // GitLab-style expects added/modified/removed arrays. Azure DevOps push payload does not include them by default.
            $commitsOut[] = [
                'id'        => $c['commitId'] ?? null,
                'message'   => $message,
                'title'     => $title,
                'timestamp' => $ts,
                'url'       => $c['url'] ?? null,
                'author'    => [
                    'name'  => $c['author']['name']  ?? $userName,
                    'email' => $c['author']['email'] ?? ($userEmail ?? ''),
                ],
                'added'    => [],
                'modified' => [],
                'removed'  => [],
            ];
        }

        $projectId = $project['id'] ?? null; // Note: GUID in ADO; keep as string.
        $repoId    = $repo['id'] ?? null;

        // Build a minimal-but-compatible "project" object in the target schema.
        $targetProject = [
            'id'                => $projectId ?? $repoId,
            'name'              => $project['name'] ?? ($repo['name'] ?? null),
            'description'       => null,
            'web_url'           => $remoteUrl,
            'avatar_url'        => null,
            'git_ssh_url'       => null,
            'git_http_url'      => $remoteUrl,
            'namespace'         => $project['name'] ?? null,
            'visibility_level'  => null,
            'path_with_namespace' => $this->joinPath($project['name'] ?? null, $repo['name'] ?? null),
            'default_branch'    => $this->stripRefPrefix($defaultRef),
            'ci_config_path'    => null,
            'homepage'          => $remoteUrl,
            'url'               => $remoteUrl,
            'ssh_url'           => null,
            'http_url'          => $remoteUrl,
        ];

        $targetRepository = [
            'name'             => $repo['name'] ?? null,
            'url'              => $remoteUrl,
            'description'      => null,
            'homepage'         => $remoteUrl,
            'git_http_url'     => $remoteUrl,
            'git_ssh_url'      => null,
            'visibility_level' => null,
        ];

        // Final target payload: matches the push schema fields you provided.
        $out = [
            'object_kind'        => 'push',
            'event_name'         => 'push',
            'before'             => $before,
            'after'              => $after,
            'ref'                => $ref,
            'ref_protected'      => null,
            'checkout_sha'       => $after,
            'message'            => $ado['message']['text'] ?? null,

            'user_id'            => $userId,
            'user_name'          => $userName,
            'user_username'      => $userUsername,
            'user_email'         => $userEmail,
            'user_avatar'        => null,

            'project_id'         => $projectId,
            'project'            => $targetProject,

            'commits'            => $commitsOut,
            'total_commits_count'=> count($commitsOut),
            'push_options'       => (object)[], // JSON "{}"
            'repository'         => $targetRepository,

            // Keep the original payload "just in case"
            $this->originalKey   => $ado,
        ];

        return $out;
    }

    private function readBody(ServerRequestInterface $request): string
    {
        $body = $request->getBody();

        // Ensure we read from start if possible
        if ($body->isSeekable()) {
            $body->rewind();
        }

        // getContents() reads from current pointer; after rewind() it's full body
        return $body->getContents();
    }

    private function firstLine(string $s): string
    {
        $s = str_replace(["\r\n", "\r"], "\n", $s);
        $pos = strpos($s, "\n");
        return $pos === false ? $s : substr($s, 0, $pos);
    }

    private function guessUsername(?string $email, ?string $displayName): ?string
    {
        if (is_string($email) && $email !== '' && str_contains($email, '@')) {
            return strstr($email, '@', true) ?: $email;
        }
        return $displayName ?: null;
    }

    private function stripRefPrefix(?string $ref): ?string
    {
        if (!is_string($ref) || $ref === '') {
            return null;
        }
        return str_starts_with($ref, 'refs/heads/') ? substr($ref, strlen('refs/heads/')) : $ref;
    }

    private function joinPath(?string $a, ?string $b): ?string
    {
        $a = is_string($a) && $a !== '' ? $a : null;
        $b = is_string($b) && $b !== '' ? $b : null;
        if ($a === null && $b === null) return null;
        if ($a === null) return $b;
        if ($b === null) return $a;
        return $a . '/' . $b;
    }
}