# Lernperiode-12
In diesem Projekt entwickeln wir ein interaktives Rätselspiel auf Roblox, bei dem die Spieler herausfinden müssen, welchen berühmten Fußballspieler sie sind. Das Spiel beginnt auf einer zentralen Plattform, die mit verschiedenen Tischen und Stühlen ausgestattet ist. Sobald sich zwei Personen an einem Tisch gegenübersitzen, startet die Runde automatisch.
Die Besonderheit der Spielmechanik ist dass jeder nur die Fußballer-Identität seines Gegners sieht, kennt aber seine eigene nicht. Über ein Menü mit vorgefertigten Fragen kann man sein Gegenüber ausfragen, um durch das Ausschlussverfahren die eigene Identität zu erraten. Wer zuerst richtig liegt, gewinnt die Runde und erhält als Belohnung In-Game-Geld. Mit diesem Verdienst können im integrierten Shop anschließend neue Stuhldesigns und weitere Gegenstände freigeschaltet werden.

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

Heute habe ich das Geld- und Shop-System für unser Spiel fertiggestellt. Zusammen mit Nena habe ich zuerst programmiert, dass der Gewinner nach einer Runde automatisch 50 CHF bekommt. Danach habe ich den Shop gemacht, damit man sich mit diesem Geld neue Stühle kaufen kann. Zum Schluss habe ich noch dafür gesorgt, dass die Käufe gespeichert werden, man behält die gekauften Stühle also und kann sie später jederzeit wieder kostenlos ausrüsten.

**Mina**
- [x] Das bisherige Fragensystem überarbeiten und vorgefertigte Fragen einbauen
- [x] Die Ja- und Nein-Buttons entfernen und stattdessen ein Textfeld für Antworten machen
- [x] Das Spiel an das neue Frage- und Antwortsystem anpassen

Ich habe das bisherige Fragensystem überarbeitet und vorgefertigte Fragen eingebaut, die man während dem Spiel auswählen kann. Ausserdem habe ich die Ja- und Nein-Buttons entfernt und durch ein Textfeld ersetzt, damit man eigene Antworten schreiben kann. Danach habe ich den Spielablauf an das neue System angepasst.

**Joshua**
- [x] Vorgefertigte Fragen erstellen und ins Spiel einbauen
- [x] Die Antworten zwischen den beiden Spielern über das Textfeld anzeigen
- [x] Zusammen mit Mina das neue Fragensystem testen und verbessern

Ich habe zusammen mit Mina am neuen Fragensystem gearbeitet. Wir haben die vorgefertigten Fragen eingebaut und dafür gesorgt, dass die Antworten beim anderen Spieler angezeigt werden. Danach haben wir das neue System nochmals überprüft und angepasst.


## 12.11

**Nena**
- [x] Austellung von den Stühlen erstellen, sodass man sieht wie die stühle aussehen vor dem einkaufen
- [ ] Designs von Stühlen ausbauen
- [x] Andere Gegenstände in unseren Shop hinzufügen (Skins, Accessories,....)

Wir haben den Shop um eine drehbare 3D-Vorschau erweitert, damit man die Stühle vor dem Kauf ansehen kann. Die Vorschau ist nur im Shop sichtbar

**Maja**
- [x] Alles auf eine Sprache einstellen (Alles nur auf English)
- [ ] Designs von Stühlen ausbauen
- [x] Andere Gegenstände in unseren Shop hinzufügen (Skins, Accessories,....)

Für das dezentral a. Paket habe ich mit hilfe von Mina alles auf eine Sprache gewechselt, und zwar auf Englisch. Dann haben ich und Nena zusammen gemerkt, dass Merge-Konflikte entstehen, da wir alle nur an 3 Dateien arbeiten. Durch diese Merge-Konflikte haben wir gemerkt, dass es sinnvoll wäre, den Code auf verschiedene Dateien zu verteilen, um diese Merge-Konflikte zu vermeiden. Dann habe ich noch währenddessen mit Nena uns ein wenig Gedanken gemacht, wie wir die Designs der Stühle ausbauen möchten.
Dann habe ich mit Nena andere Gegenstände in unser Shop hinzugefügt (z.B. eine Krone). Heute konnten wir nicht so gut vorankommen, da durch unsere Branch aufteilung und einen Force push wir Code "verloren" haben und es dauerte eine Weile bis wir diesen Code wieder vorhanden hatten.

**Mina**
- [x] Alles auf eine Sprache einstellen (Alles nur auf English)
- [x] Nach anderen kleinen Problemen suchen, die man verbessern sollte
- [x] Mehr Fragen hinzufügen beim Fussball Spieler raten

Ich habe zusammen mit Maja dafür gesorgt, dass das ganze Spiel auf Englisch eingestellt ist. Danach habe ich nach kleineren Problemen gesucht, die man noch verbessern könnte. Ausserdem habe ich weitere vorgefertigte Fragen zum Fussballspieler-Raten hinzugefügt, damit die Spieler mehr Auswahl haben.

**Joshua**
- [X] Fragen anpassen zu den Informationen die von den Fussball Spielern vorhanden sind
- [x] Die funktion von einem "rematch" einbauen
- [x] Nach anderen kleinen Problemen suchen, die man verbessern sollte

Ich habe die vorgefertigten Fragen überarbeitet und erweitert, sodass sie besser zu unseren Fussballspielerdaten passen. Ausserdem habe ich eine Rematch-Funktion eingebaut, bei der beide Spieler nach einer Runde entscheiden können, ob sie nochmals gegeneinander spielen möchten. Danach habe ich noch nach kleineren Problemen gesucht und Verbesserungen vorgenommen.

## 20.11
**Nena**
- [x] Eigene Fragen senden: Ein Eingabefeld mit einem Senden-Button ergänzen. Die Frage soll dem Mitspieler angezeigt werden und mit Ja oder Nein beantwortet werden können.
- [x] Benutzeroberfläche verbessern: Buttons, Beschriftungen und Eingabefelder übersichtlicher gestalten. Dabei die Schwierigkeiten berücksichtigen, die beim Ausprobieren des Spiels aufgetreten sind.
- [x] Tutorial einbauen: Eine kurze Anleitung zu Spielstart, Fragen und Vermutungen erstellen. Spieler sollen sie über einen Hilfe-Button öffnen und wieder schliessen können.

Ich habe ein Eingabefeld für eigene Fragen mit einem Senden-Button eingebaut. Der Mitspieler kann die Fragen mit Ja oder Nein beantworten. Ausserdem habe ich die Benutzeroberfläche übersichtlicher gemacht und eine kurze Spielanleitung ergänzt, die man über einen Hilfe-Button öffnen und schliessen kann.

**Maja**
- [x] Shop-Code aufteilen: Die Shop-Oberfläche, Kaufverarbeitung und Artikeldaten in getrennten Dateien organisieren. Dadurch könnt ihr Änderungen leichter unabhängig voneinander bearbeiten.
- [ ] Ein neues Stuhldesign erstellen: Einen zusätzlichen Stuhl gestalten und als eigenes Modell speichern. Das Design soll sich sichtbar von den bisherigen Stühlen unterscheiden.
- [x] Einen Fisch als Sitzobjekt erstellen: Ein Fischmodell mit einer Sitzfunktion ergänzen. Prüfen, ob sich Spieler darauf setzen und wieder aufstehen können.

Für das  dezentral a. Paket habe ich die eine riesie datei mit der spiellogik, stuhllogik etc. in kleiner dateien aufgeteilt um merge konflikte zu vermeiden und um das ganze übersichtlicher zu gestalten. Dann habe ich mehrere optionen ausprobiert um einen fishstuhl zu erstellen. Zuerst habe ich selbst einen fisch gebaut mit mehrern teilen doch das sah nicht so gut aus und dann bin ich auf die idee gekommen einen vorgefertigten fisch einzubauen mit der sitzfunkion. Was jetzt noch jedoch fehlt ist dass das spiel startet wenn beide auf den fischen sitzen.

**Mina**
- [x] Levels beim Spiel hinzufügen (easy, intermediate, difficult,...)
- [x] Funktion einbauen dass Spieler Geld auf das Spiel wetten können.
- [x] Funktion einbauen zum entscheiden ob man überhaupt in der Runde wetten möchte

Ich habe zusammen mit Joshua die verschiedenen Schwierigkeitsstufen ins Spiel eingebaut. Danach habe ich einen freiwilligen Bonus-Modus hinzugefügt. Nach der Schwierigkeitsauswahl erscheint jetzt ein Fenster, in dem beide Spieler entscheiden können, ob sie mit Bonus spielen möchten. Wenn beide Ja auswählen, bekommt der Gewinner zusätzlich 25 CHF, also insgesamt 75 CHF. Wenn einer Nein auswählt, läuft das Spiel normal weiter und der Gewinner erhält wie bisher 50 CHF. Das Ganze funktioniert auch bei einem Rematch, da man vor jeder neuen Runde wieder entscheiden kann.

**Joshua**
- [X] Mehr Fussball Spieler Daten hinzufügen
- [X] Levels beim Spiel hinzufügen (easy, intermediate, difficult,...)
- [X] Fussball Spieler in Levels nach schwierigkeit einteilen.

Für das dezentral a. Arbeitspaket habe ich mir 40 neue Fussballer mit Daten herausgesucht, dass man verschiedene Schwierigkeitstufen im Spiel einbauen kann. Danach habe ich alle 60 Fussballer in die 3 verschiedene Schwierigkeitsstufen (Easy, Intermediate und Hard) eingeteilt, dass es jetzt überall 20 Fussballer gibt. Zum Schluss habe ich die Schwierigkeitsstufen ins Spiel hinzugefügt. Wenn man jetzt eine Runde startet, kann man die Schwierigkeit der Runde auswählen und beide Spieler bekommen einen Fussballer aus der ausgewählet schwierigkeit zugelost.



## 27.11
**Nena**
- [ ] Weniger Text in der Spiel Tabelle haben, sodass es weider übersichtlicher ist.
- [ ] Eingaben und ausgaben der Spieler besser verteilen, sodass die Spieler es nachvolziehen können.
- [ ] Ein neues Stuhldesign erstellen: Einen zusätzlichen Stuhl gestalten und als eigenes Modell speichern. Das Design soll sich sichtbar von den bisherigen Stühlen unterscheiden. Z.b. wir haben schon einen Fisch als Stuhl, dann kann man weitere "komische" Stühle hinzufügen.


**Maja**
- [ ] Dem Fisch stuhl die funktion zum spiel starten hinzuzufügen
- [ ] Entscheiden ob der Fischstuhl gekauft werden soll oder überall steht. Nach der Entscheidung das ausgewählte umsetzen.
- [ ] Ein neues Stuhldesign erstellen: Einen zusätzlichen Stuhl gestalten und als eigenes Modell speichern. Das Design soll sich sichtbar von den bisherigen Stühlen unterscheiden. Z.b. wir haben schon einen Fisch als Stuhl, dann kann man weitere "komische" Stühle hinzufügen.


**Mina**
- [x] Geldsystem so anpassen, dass die Spieler ihr Geld behalten, wenn sie das Spiel verlassen und später wieder beitreten.
- [ ] Fragensystem überarbeiten, sodass die beiden Spieler abwechselnd Fragen stellen müssen und nicht gleichzeitig fragen können.
- [ ] Die Anzeige der Antworten verbessern, damit man deutlicher sieht, wenn der Gegner eine Frage beantwortet hat.

**Joshua**
- [x] Eine Anzeige einbauen, die zeigt, welcher Spieler gerade an der Reihe ist, zum Beispiel «Your Turn» und «Opponent's Turn».
- [ ] Die gestellten Fragen und Antworten übersichtlicher anzeigen, damit man erkennt, welche Antwort zu welcher Frage gehört.
- [ ] Das überarbeitete Fragensystem und die Speicherfunktion zusammen mit Mina testen und mögliche Fehler beheben.
