# Fragen, übersichtliche Bedienung und Tutorial – aktuelle Version

Grundlage ist ausschliesslich Lernperiode-12(4).zip, hochgeladen am 19.11.2026. Die Ergänzung wurde an die dort enthaltene modulare Serverstruktur, die vorgegebenen Fragen, freie Textantworten und den Rematch angepasst.

## Einbauen

Dieses ZIP enthält nur neun neue Dateien. Kopiere den Inhalt des enthaltenen Ordners Lernperiode-12 in euren aktuellen Projektordner. Dort liegen bereits default.project.json und shop-erweiterung.project.json.

Hinzu kommen:

- spielerlebnis.project.json
- src/client/ExperienceBootstrap.client.luau
- src/client/PlayerExperience/ mit sechs Modulen
- docs/Spielkomfort-ANLEITUNG.md

Keine Originaldatei aus Lernperiode-12(4).zip wird überschrieben. Wenn du die Ergänzung für die ALTE Projektversion schon kopiert hast, ersetze nur die gleichnamigen Dateien der bisherigen PlayerExperience-Ergänzung durch diese aktuelle Fassung. Andere Teamdateien nicht ersetzen.

1. In Roblox Studio Play stoppen.
2. Die neuen Dateien kopieren und die src-Ordner zusammenführen. Kein zusätzliches Lernperiode-12-Unterverzeichnis im Projektordner anlegen.
3. Bisherigen Rojo-Server mit Strg+C stoppen.
4. Im Projektordner den neuen Startbefehl ausführen:

   ```powershell
   & "C:\Users\nenaz\Tools\Rojo\rojo.exe" serve spielerlebnis.project.json
   ```

5. In Roblox Studio über Rojo mit localhost:34872 verbinden und synchronisieren. Nur einen Rojo-Server für dieses Spiel verwenden.
6. Play starten. Oben links erscheint „HOW TO PLAY“. Für die Rundenbedienung mit zwei Spielern an einen Spieltisch setzen.

### Warum eine neue Startdatei?

Die hochgeladene default.project.json verweist noch auf src/ServerScriptService/TwoPlayerGame.server.lua. Diese Datei gibt es im neuen Upload nicht mehr: Eure Kollegin hat sie in den Ordner src/ServerScriptService/TwoPlayerGame mit init.server.lua und Modulen aufgeteilt.

Die hochgeladene shop-erweiterung.project.json lädt hingegen noch die ältere monolithische Datei ShopErweiterung/TwoPlayerGame.ShopBasis.server.lua. Damit kämen die neueren GameService-Funktionen für freie Antworten und Rematch nicht zur Ausführung.

Die ZUSÄTZLICHE spielerlebnis.project.json übernimmt die Shop-Konfiguration vollständig und ändert genau eine Zuordnung: TwoPlayerGame lädt nun den aktuellen Modulordner src/ServerScriptService/TwoPlayerGame. So bleiben Shop, Vorschau und Accessoires eingebunden, während nur eine Fassung der Spiel-/Kauflogik läuft. Beide vorhandenen JSON-Dateien und alle Servermodule bleiben unverändert.

src/client wird bereits eingebunden. Wegen der dortigen init.client.luau bildet Rojo den Ordner als LocalScript „Client“ ab. Der neue Bootstrap und der Modulordner sind dessen Kinder; ihre require-Pfade passen dazu.

## Die drei Arbeitspakete

### Eigene Fragen senden

- Eigene Frage eintippen und „SEND QUESTION“ oder Enter verwenden.
- Wegklicken sendet nichts. Leere, zu lange Texte und schnelle Doppelklicks werden abgefangen.
- Die Frage erscheint beim Mitspieler in einem eigenen Bereich.
- Der Mitspieler kann mit YES/NO antworten. Die neu hinzugefügte freie Textantwort eures Teams bleibt zusätzlich verfügbar.
- Nach dem Abschicken wird auf ANSWER_SENT oder ANSWER_ERROR des aktuellen Servers gewartet. Bei einem Fehler lässt sich erneut antworten. Eine verspätete Bestätigung für die ältere Frage sperrt nicht die inzwischen neu eingegangene Frage.
- Alle tatsächlichen vorgegebenen Fragen werden aus eurer vorhandenen QuestionList übernommen und als „QUICK QUESTIONS“ angezeigt. Sie werden nicht durch eine veraltete Liste ersetzt. Der bisherige Eintrag „Custom question:....“ ist als Platzhalter durch das echte Eingabefeld ersetzt.
- Es gibt keine neue Server-Weiterleitung. GameActionEvent mit QUESTION/ANSWER/GUESS und die vorhandene TextUtils-Filterung bleiben zuständig.

### Benutzeroberfläche verbessern

- Getrennte Karten für Fragen, empfangene Fragen/Antworten und Vermutungen.
- Eigener „SUBMIT GUESS“-Button sowie Enter zum Absenden.
- Eigene Rückmeldungen, deutliche Beschriftungen, gut lesbare Farben und grössere Eingabefelder.
- Spielerinformationen werden klar als Informationen über den GEGNER bezeichnet. Sie verraten nicht die eigene Lösung.
- Scrollbarer Inhalt und untereinander angeordnete Bereiche bei schmalen Fenstern.
- SHOP öffnet den vorhandenen Shop. Vorschau und Accessoires werden weiterhin von den bestehenden Shopdateien gesteuert.
- Das vorhandene „PLAY AGAIN?“-Fenster, seine Abstimmung und seine Event-Handler bleiben original und zugänglich. Es wird keine zweite Rematch-Funktion eingebaut.

„Unverändert“ bedeutet: Keine vorhandene Projektdatei, kein Servermodul und keine Spielregel wird bearbeitet. Während einer Runde blendet der neue Client-Adapter die bisherigen Runden-Bedienelemente nur lokal aus und zeigt die neue Bedienung mit denselben Fähigkeiten plus eigenen Fragen/Ja-Nein-Auswahl. Alte Instanzen und fremde Event-Handler werden nicht gelöscht. Kamera, Warteanzeige, Geldanzeige, Ergebnisse und Rematch bleiben vom vorhandenen Client gesteuert.

### Tutorial einbauen

- Aufruf über „HOW TO PLAY“.
- Sechs Schritte zu Platz nehmen, eigener/gegnerischer Identität, Fragen, Antworten, Vermutungen sowie Hilfe/Shop/Rematch.
- Vorwärts, zurück, DONE und Schliessen mit X oder Escape.
- Scrollbarer Inhalt. Die Runde läuft währenddessen weiter und wird nicht pausiert.
- Die neuen sichtbaren Texte sind Englisch, passend zum aktuellen Team-Client.

## Neue Dateistruktur

| Datei | Aufgabe |
|---|---|
| spielerlebnis.project.json | Startet die aktuellen Team-Module zusammen mit dem bestehenden Shop |
| src/client/ExperienceBootstrap.client.luau | Startet die Ergänzung einmal pro Client |
| src/client/PlayerExperience/Controller.lua | Eingaben und vorhandene Spielnachrichten verbinden |
| src/client/PlayerExperience/Protocol.lua | Validierung und Anzeigezustand inkl. Antwortbestätigungen |
| src/client/PlayerExperience/LegacyBridge.lua | Aktuelle QuestionsFrame/QuestionList erkennen; Team-UI vorsichtig anbinden |
| src/client/PlayerExperience/GameView.lua | Rundenoberfläche, dynamische Vorgaben und Antwortfelder |
| src/client/PlayerExperience/Tutorial.lua | Sechs Hilfeschritte |
| src/client/PlayerExperience/Widgets.lua | Gemeinsame Farben, Felder und Buttons |
| docs/Spielkomfort-ANLEITUNG.md | Diese Anleitung |

Serveraufteilung, Spielerdaten, Shopartikel, Preise, Siegprämie, Map und Sitzlogik werden aus dem aktuellen Upload weiterverwendet. Die alte ShopBasis-Kopie bleibt als Datei erhalten, wird durch die neue Konfiguration aber nicht zusätzlich gestartet.

## Geprüft

- Syntax der neuen Lua/Luau-Dateien und Rojo-Pfade geprüft.
- Alle vorhandenen Projektdateien bytegenau mit Lernperiode-12(4).zip verglichen: unverändert.
- Neue Startkonfiguration mit Shop-Konfiguration verglichen: Nur der TwoPlayerGame-Pfad unterscheidet sich.
- Simulierte Client-Integration mit den tatsächlichen neuen Modulen: eigene Fragen, vorgegebene Fragen, kein Senden bei Fokusverlust, Enter, Doppelklickschutz, Ja/Nein, freie Antworten, Serverfehler/Bestätigungen und verspätete Bestätigung bei einer neuen Frage.
- Tutorial vor/zurück/X/Escape, Shop öffnen/schliessen, originales Rematch-Fenster, Rundenende, neue Runde, Respawn, schmales Layout und Wiederherstellung der Originalbedienelemente geprüft.
- Aktuellen unveränderten GameService und TextUtils mit simulierten Roblox-Diensten ausgeführt: gefilterte Frage beim richtigen Gegner, Ja/Nein und freie Antworten, Antwortbestätigung, Filterfehler mit erneutem Versuch, falsche/richtige Vermutung, 50-CHF-Siegprämie und vorhandene Rematch-Abstimmung mit neuer Runde.
- Schutzfälle: Bei unbekannter Team-UI bleibt die Originalbedienung aktiv. Ein Fehler beim Aufbau der neuen Anzeige lässt die Originalkontrollen ebenfalls bestehen.

Roblox Studio ist in dieser Umgebung nicht vorhanden. Die Simulation ersetzt keinen Test des tatsächlichen Renderings, der Textfilterdienste oder der Netzwerkzustellung zwischen echten Roblox-Clients.

## Noch in Studio prüfen

1. Tutorial öffnen, alle Schritte durchgehen und schliessen.
2. Mit zwei Spielern sitzen und Rundenstart/Kamera prüfen.
3. Eigene Frage tippen, wegklicken: keine Nachricht. Danach mit Senden/Enter abschicken und beim Gegner sehen.
4. YES/NO und anschliessend die freie Textantwort testen. Auf die Serverbestätigung achten.
5. Die vorhandenen QUICK QUESTIONS ausprobieren. Alle echten Vorgaben sollen verfügbar sein.
6. Falschen/richtigen Namen vermuten, Ergebnis und 50 CHF prüfen.
7. PLAY AGAIN? mit beiden Spielern bestätigen und danach einmal ablehnen.
8. Shop öffnen/schliessen, Vorschau und Accessoires prüfen.
9. Fenster schmal stellen und alle Bereiche per Scrollen erreichen.

## Bestehende Grenzen und Rückgängig machen

Der aktuelle TextUtils-Serverfilter begrenzt Texte auf 100 Bytes. Die neue Validierung lehnt längere Eingaben ab, ohne Zeichen abzuschneiden. Bei Umlauten/Emojis kann die Grenze früher erreicht sein. Der Server bestätigt Antworten, liefert aber keine gesonderte Zustellbestätigung für Fragen; „Submitted“ bedeutet an den vorhandenen Server übergeben. Die Ergänzung ändert daran nichts.

Für die ursprüngliche Clientbedienung nur ExperienceBootstrap.client.luau und den neuen Ordner PlayerExperience entfernen, synchronisieren und Play neu starten. Die neue spielerlebnis.project.json kann weiter die aktuellen Servermodule und den Shop laden. Keine Originaldatei muss zurückkopiert werden.
