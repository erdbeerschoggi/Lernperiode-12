# Lernperiode-12
Beschreibung des Projekts wäre gut!!!

# Rollen Aufteilung
- CEO: Mina
- CTO: Maja
- COO: Nena
- Head of R&D: Joshua

## 23.10
**Arbeitspakete für alle**
- [x] Umgebung für die entwicklung vom Spiel einstellen und das projekt mit allen teilen
- [x] Aufgaben für unseres Projekt genau erstellen aufteilen
- [x] Sich mit Luau bekannt machen

**Mina und Joshua**
- [x] Spiel anfangen zu bauen

**Maja**
- [ ] Herausfinden wie wir das Projekt auf github hochladen.

**Nena**
- [x] Gantt-Chart anpassen

Für das Paket „Asynchron dezentral“ haben wir zunächst alle Roblox Studio heruntergeladen und das Projekt innerhalb der Gruppe geteilt. Danach haben wir erste Objekte direkt in Roblox Studio erstellt, um uns mit dem Programm vertraut zu machen. Im Anschluss haben wir die grundlegende Spiellogik implementiert: Zwei Spieler können nun gemeinsam ein Spiel starten und dieses komplett durchspielen, vorerst jedoch noch ohne Datenverarbeitung. Darüber hinaus haben wir uns sehr lange mit Git beschäftigt, da die benötigten Extensions, um das Projekt auf GitHub hochzuladen, zu einigen Komplikationen geführt haben.

## 30.10

**Nena**
- [x] Bilder zu den Fussballern suchen (dezentral a.)
- [x] Sich über die Verwendung der Bilder von Fussballern in Roblox informieren
- [x] Extensions einstellen zum Code auf github hochladen zu können.

Im dezentral arbeitspaket habe ich bilder von den CLub logos für jeden Spieler geammelt. Der plan war Bilder von den Spielern einzeln zu nehmen aber da es oft nich möglich ist oder zu kompliziert wegen dem copyright habe ich mich dazu entschieden die Fussballmannschafts logos zu sammeln. Alle logos sind beschriftet und weisen auch an wo in der exel tabelle es dazugehört.

**Maja** 
- [x] Anderen helfen die extensions für das hochladen vom code auf github einzustellen.
- [x] Informationen zum gegnerischen Spieler an der Seite hinzufügen
- [x] herausfinden wie man die skripte von Roblox Studio auf Github hochladen kann. (dezentral A.)

Für mein dezentrales A. Arbeitspaket habe ich mich informiert, welche die beste und meistverwendete Variante für die Verbindung zwischen GitHub und Roblox Studio ist. Letztes Mal habe ich es schon mit Rojo ausprobiert, doch fand das als ineffizient. Es stellte sich jedoch heraus, dass die Arbeit mit Rojo in VS Code am effizientesten sei und dass alle anderen Entwickler genau das Gleiche. Ich habe alles eingerichtet und den Code auf GitHub gepusht, der von unserer letzten Sitzung relevant war. Danach habe ich den anderen auch alle extensions eingerichtet sodass alle skripte von Roblox studio auf git hochladen können und mich noch mehr darüber informiert wie genau wir diese extension am effizientesten benutzen können.

**Mina**
- [x] Lobby verbessern: Rand einbauen, Baseplate entfernen und Shop-Button hinzufügen (dezentral A.)
- [x] Fussballspieler mit Daten erstellen und den Spielern zufällig zuweisen
- [x] Extensions einstellen zum Code auf github hochladen zu können.

Für mein dezentrales Arbeitspaket habe ich an der Lobby weitergearbeitet. Ich habe einen unsichtbaren Rand gemacht, damit man nicht mehr von der Map runterfallen kann. Danach habe ich die Baseplate entfernt, weil sie nicht gut zum Design gepasst hat. Zusätzlich habe ich links auf dem Bildschirm einen Shop-Button eingebaut, den wir später noch weiter ausbauen können.

**Joshua**
- [x] Lobby fürs Spiel gestalten (dezentral A.)
- [x] Zufällige Spielervergabe hinzufügen
- [x] Extensions einstellen zum Code auf github hochladen zu können.

Für mein dezentrales Arbeitspaket habe ich an der Lobby weitergearbeitet. Zuerst habe ich Mina dabei geholfen, den Shop-Button fertigzustellen. Danach habe ich mich von bereits existierenden Spielen inspirieren lassen und einige Designelemente herausgesucht, die ich in unser Spiel implementieren wollte. Anschliessend habe ich an den Rändern Palmen platziert und das Design des Himmels angepasst, dass es etwas lebendiger wirkt.

## 06.11

**Nena**
- [x] Geldsystem einbauen, damit man nach einem Sieg 50 CHF bekommt
- [x] Verschiedene farbige Stühle erstellen, die man später im Shop kaufen kann
- [x] Die Stühle in den Shop einfügen und Preise dafür festlegen

Ich habe den bestehenden Geld- und Shopcode von Maja erweitert und die Stuhlfarben Grün, Violett und Gold mit passenden Preisen ergänzt. Die Geldanzeige zeigt jetzt CHF an und ist auch ausserhalb einer Spielrunde sichtbar. Ausserdem habe ich einen Fehler behoben, damit bereits gekaufte Farben auch bei 0 CHF kostenlos ausgewählt werden können. Der besetzte Stuhl übernimmt die ausgewählte Farbe und erhält beim Aufstehen seine Originalfarbe zurück. Den GUI-Code habe ich korrekt in der Clientdatei eingeordnet, die alte Datei gesichert und VS Code über Rojo mit Roblox Studio verbunden. Die bestehende Spiellogik und die Belohnung von 50 CHF pro Sieg wurden beibehalten.

**Maja**
- [x] Die 50 CHF nach einem Sieg mit der Geldanzeige verbinden
- [x] Programmieren, dass man mit dem Geld neue Stühle kaufen kann
- [x] Dafür sorgen, dass gekaufte Stühle später auch benutzt werden können

Heute habe ich das Geld- und Shop-System für unser Spiel fertiggestellt. Zusammen mit Nena habe ich zuerst programmiert, dass der Gewinner nach einer Runde automatisch 50 CHF bekommt. Danach habe ich den Shop gemacht, damit man sich mit diesem Geld neue Stühle kaufen kann. Zum Schluss habe ich noch dafür gesorgt, dass die Käufe gespeichert werden – man behält die gekauften Stühle also und kann sie später jederzeit wieder kostenlos ausrüsten.


**Mina**
- [ ] Das bisherige Fragensystem überarbeiten und vorgefertigte Fragen einbauen
- [ ] Die Ja- und Nein-Buttons entfernen und stattdessen ein Textfeld für Antworten machen
- [ ] Das Spiel an das neue Frage- und Antwortsystem anpassen

**Joshua**
- [ ] Vorgefertigte Fragen erstellen und ins Spiel einbauen
- [ ] Die Antworten zwischen den beiden Spielern über das Textfeld anzeigen
- [ ] Zusammen mit Mina das neue Fragensystem testen und verbessern
