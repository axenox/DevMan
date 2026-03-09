### Apps & Features

In diesem Bereich wird die funktionale Struktur der Apps innerhalb eines Projekts verwaltet. Apps werden hier in Module und Features gegliedert. Dadurch können Funktionen einer App strukturiert organisiert und mit Tickets sowie Testfällen verknüpft werden.

Die Seite ist in drei Bereiche unterteilt: Applications, Modules und Features. Die Auswahl erfolgt hierarchisch. Zunächst wird eine App ausgewählt, anschließend ein Modul und danach ein Feature.

<div class="image-container" id="2_DevMan-apps-features-image-1">
  <img src="Bilder/2026-02_11_Apps_Features.png"
  <div class="caption">
  <!-- BEGIN ImageCaptionNr: -->
Abbildung 1:
<!-- END ImageCaptionNr -->DevMan: Apps & Features</div>
</div>

#### <span class="circle red">1</span> Applications

Beim Anlegen einer App werden grundlegende Informationen wie App name und Client hinterlegt. Optional können zusätzlich technische Informationen wie Package URL, Development URL, Testing URL oder die Latest version gepflegt werden. Diese Angaben dienen hauptsächlich der Dokumentation der App sowie der schnellen Referenz auf Entwicklungs- und Testumgebungen.

<div class="image-container" id="2_DevMan-apps-features-image-2">
  <img src="Bilder/2026-02_11_Apps_Features_02.png"
  <div class="caption">
  <!-- BEGIN ImageCaptionNr: -->
Abbildung 1:
<!-- END ImageCaptionNr -->Apps: New</div>
</div>


#### <span class="circle red">2</span> Modules

Der mittlere Bereich zeigt die Module der ausgewählten App. Module dienen der funktionalen Strukturierung einer App und gruppieren zusammengehörige Features innerhalb eines größeren Funktionsbereichs. Über die Aktionsleiste können Module erstellt, bearbeitet, kopiert oder gelöscht werden. Beim Anlegen eines Moduls werden der Module name sowie die zugehörige App festgelegt. Optional können zusätzlich eine Description sowie ein Test setup gepflegt werden, beispielsweise um technische Hinweise oder projektspezifische Testinformationen für dieses Modul zu dokumentieren.

<div class="image-container" id="2_DevMan-apps-features-image-3">
  <img src="Bilder/2026-02_11_Apps_Features_03.png"
  <div class="caption">
  <!-- BEGIN ImageCaptionNr: -->
Abbildung 1:
<!-- END ImageCaptionNr -->Modules: New</div>
</div>

#### <span class="circle red">3</span> Features

Im rechten Bereich werden die Features des ausgewählten Moduls angezeigt. Features beschreiben einzelne Funktionen oder funktionale Erweiterungen innerhalb eines Moduls und bilden die Grundlage für die Zuordnung von Testfällen. Die Übersicht zeigt unter anderem den Feature name, die Priorität, vorhandene Test cases sowie Informationen zur letzten Änderung. Features können optional hierarchisch organisiert werden, indem über das Feld Subfeature of eine Zuordnung zu einem übergeordneten Feature erfolgt.

Im unteren Bereich eines Feature-Dialogs werden die zugehörigen Test cases angezeigt. Hier können Testfälle erstellt, bearbeitet oder direkt ausgeführt werden. Außerdem können Testfälle als ToDo markiert oder einem Testplan hinzugefügt werden. Der Status eines Testfalls zeigt den aktuellen Stand des Tests, beispielsweise Passed oder ToDo. Weitere Informationen zur Verwaltung von Testfällen sind im Kapitel Testing beschrieben.

<div class="image-container" id="2_DevMan-apps-features-image-5">
  <img src="Bilder/2026-02_11_Apps_Features_05.png"
  <div class="caption">
  <!-- BEGIN ImageCaptionNr: -->
Abbildung 1:
<!-- END ImageCaptionNr -->Features: Edit</div>
</div>

Beim Anlegen eines Features werden der Feature name, das zugehörige Module sowie optional ein übergeordnetes Feature und eine Priority definiert. Zusätzlich können innerhalb eines Features Testfälle, Dateien oder Tickets hinterlegt und verwaltet werden.

<div class="image-container" id="2_DevMan-apps-features-image-4">
  <img src="Bilder/2026-02_11_Apps_Features_04.png"
  <div class="caption">
  <!-- BEGIN ImageCaptionNr: -->
Abbildung 1:
<!-- END ImageCaptionNr -->Features: New</div>
</div>
