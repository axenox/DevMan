<?php
namespace axenox\DevMan\Facades\WebhookFacade\Middleware;

use GuzzleHttp\Psr7\Utils;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

/**
 * Translates Azure DevOps Git push webhooks into a GitHub-like payload
 * expected by ProcessVcsUpdate while preserving the original webhook body.
 * 
 * See example messsage in `getExamplePayload()`
 * 
 */
class AzureDevOpsToGithubPushMiddleware implements MiddlewareInterface
{
    /**
     * {@inheritDoc}
     */
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $body = $request->getBody()->__toString();
        if ($body === '') {
            return $handler->handle($request);
        }

        $payload = json_decode($body, true);
        if (! is_array($payload) || ! $this->isAzureDevOpsPush($request, $payload)) {
            return $handler->handle($request);
        }

        $translated = $this->translateAzurePushToGithubFormat($payload);
        $json = json_encode($translated, JSON_UNESCAPED_SLASHES);
        if ($json === false) {
            return $handler->handle($request);
        }

        $request = $request
            ->withBody(Utils::streamFor($json))
            ->withParsedBody($translated)
            ->withoutHeader('Content-Length')
            ->withHeader('Content-Type', 'application/json');

        return $handler->handle($request);
    }

    /**
     * @param ServerRequestInterface $request
     * @param array $payload
     * @return bool
     */
    protected function isAzureDevOpsPush(ServerRequestInterface $request, array $payload): bool
    {
        if (($payload['eventType'] ?? null) === 'git.push') {
            return true;
        }

        if (($request->getHeaderLine('Aeg-Event-Type') !== '') || ($request->getHeaderLine('X-VSS-SubscriptionId') !== '')) {
            return isset($payload['resource']['repository']);
        }

        return isset($payload['resource']['repository']) && isset($payload['resource']['refUpdates']);
    }

    /**
     * @param array $payload
     * @return array
     */
    protected function translateAzurePushToGithubFormat(array $payload): array
    {
        $resource = $payload['resource'] ?? [];
        $repository = $resource['repository'] ?? [];
        $refUpdate = $resource['refUpdates'][0] ?? [];
        $commits = [];

        foreach (($resource['commits'] ?? []) as $commit) {
            $added = [];
            $modified = [];
            $removed = [];

            foreach (($commit['changes'] ?? []) as $change) {
                $path = $change['item']['path'] ?? ($change['newContent']['path'] ?? null);
                if ($path === null || $path === '') {
                    continue;
                }

                switch (strtolower((string) ($change['changeType'] ?? ''))) {
                    case 'add':
                    case 'branch':
                    case 'undelete':
                        $added[] = $path;
                        break;
                    case 'delete':
                        $removed[] = $path;
                        break;
                    default:
                        $modified[] = $path;
                        break;
                }
            }

            $commits[] = [
                'id' => $commit['commitId'] ?? ($commit['id'] ?? ''),
                'message' => $commit['comment'] ?? ($commit['message'] ?? ''),
                'timestamp' => $commit['author']['date'] ?? $commit['committer']['date'] ?? ($payload['createdDate'] ?? date(DATE_ATOM)),
                'url' => $commit['url'] ?? ($resource['repository']['url'] ?? ''),
                'author' => [
                    'name' => $commit['author']['name'] ?? ($commit['author']['email'] ?? 'Azure DevOps')
                ],
                'committer' => [
                    'name' => $commit['committer']['name'] ?? ($commit['committer']['email'] ?? ($commit['author']['name'] ?? 'Azure DevOps'))
                ],
                'added' => array_values(array_unique($added)),
                'modified' => array_values(array_unique($modified)),
                'removed' => array_values(array_unique($removed))
            ];
        }

        return [
            'ref' => $refUpdate['name'] ?? 'refs/heads/unknown',
            'repository' => [
                'html_url' => $repository['remoteUrl'] ?? ($repository['webUrl'] ?? ($payload['resourceContainers']['project']['baseUrl'] ?? '')),
                'homepage' => $repository['webUrl'] ?? ($repository['remoteUrl'] ?? '')
            ],
            'commits' => $commits,
            // Keep the untouched provider payload for diagnostics/reprocessing.
            'x_original_payload' => [
                'azure_devops' => $payload
            ]
        ];
    }
    
    protected function getExamplePayload(): string
    {
        return <<<JSON
{
  "subscriptionId": "00000000-0000-0000-0000-000000000000",
  "notificationId": 1,
  "id": "03c164c2-8912-4d5e-8009-3707d5f83734",
  "eventType": "git.push",
  "publisherId": "tfs",
  "message": {
    "text": "Jamal Hartnett pushed updates to Fabrikam-Fiber-Git:master."
  },
  "detailedMessage": {
    "text": "Jamal Hartnett pushed a commit to Fabrikam-Fiber-Git:master.\n - Fixed bug in web.config file 33b55f7c"
  },
  "resource": {
    "commits": [
      {
        "commitId": "33b55f7cb7e7e245323987634f960cf4a6e6bc74",
        "author": {
          "name": "Jamal Hartnett",
          "email": "fabrikamfiber4@hotmail.com",
          "date": "2015-02-25T19:01:00Z"
        },
        "committer": {
          "name": "Jamal Hartnett",
          "email": "fabrikamfiber4@hotmail.com",
          "date": "2015-02-25T19:01:00Z"
        },
        "comment": "Fixed bug in web.config file",
        "url": "https://fabrikam-fiber-inc.visualstudio.com/DefaultCollection/_git/Fabrikam-Fiber-Git/commit/33b55f7cb7e7e245323987634f960cf4a6e6bc74"
      }
    ],
    "refUpdates": [
      {
        "name": "refs/heads/master",
        "oldObjectId": "aad331d8d3b131fa9ae03cf5e53965b51942618a",
        "newObjectId": "33b55f7cb7e7e245323987634f960cf4a6e6bc74"
      }
    ],
    "repository": {
      "id": "278d5cd2-584d-4b63-824a-2ba458937249",
      "name": "Fabrikam-Fiber-Git",
      "url": "https://fabrikam-fiber-inc.visualstudio.com/DefaultCollection/_apis/git/repositories/278d5cd2-584d-4b63-824a-2ba458937249",
      "project": {
        "id": "6ce954b1-ce1f-45d1-b94d-e6bf2464ba2c",
        "name": "Fabrikam-Fiber-Git",
        "url": "https://fabrikam-fiber-inc.visualstudio.com/DefaultCollection/_apis/projects/6ce954b1-ce1f-45d1-b94d-e6bf2464ba2c",
        "state": "wellFormed",
        "visibility": "unchanged",
        "lastUpdateTime": "0001-01-01T00:00:00"
      },
      "defaultBranch": "refs/heads/master",
      "remoteUrl": "https://fabrikam-fiber-inc.visualstudio.com/DefaultCollection/_git/Fabrikam-Fiber-Git"
    },
    "pushedBy": {
      "displayName": "Jamal Hartnett",
      "id": "00067FFED5C7AF52@Live.com",
      "uniqueName": "fabrikamfiber4@hotmail.com"
    },
    "pushId": 14,
    "date": "2014-05-02T19:17:13.3309587Z",
    "url": "https://fabrikam-fiber-inc.visualstudio.com/DefaultCollection/_apis/git/repositories/278d5cd2-584d-4b63-824a-2ba458937249/pushes/14"
  },
  "resourceVersion": "1.0",
  "resourceContainers": {
    "collection": {
      "id": "c12d0eb8-e382-443b-9f9c-c52cba5014c2"
    },
    "account": {
      "id": "f844ec47-a9db-4511-8281-8b63f4eaf94e"
    },
    "project": {
      "id": "be9b3917-87e6-42a4-a549-2bc06a7a878f"
    }
  },
  "createdDate": "2026-04-15T12:20:01.2946912Z"
}
JSON;

    }
}