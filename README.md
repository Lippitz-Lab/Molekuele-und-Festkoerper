[![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]    
This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg

# Vorwort

Dies ist das Vorlesungsskript meiner Vorlesung 'Molekülphysik und Festkörperphysik I'. Sie ist eine Kursvorlesung für  Studierende im dritten Jahr des Bachelorstudiums. Bei der Auswahl und Gewichtung der Themen folgt sie sehr stark dem in Bayreuth Üblichen. Ich danke an dieser Stelle insbesondere Jürgen Köhler und Anna Köhler, deren Vorlesungsskripte mir eine große Hilfe waren.

Neben dem Skript gibt es zu jedem Kapitel  insgesamt circa eine Stunde 'Vorlesung' auf Video, in der ich mündlich durch den Text führe und dabei an den Rand kritzle.
Ich habe den Eindruck, dass es mir beim Sprechen leichter fällt, die Dinge in einen Zusammenhang zu bringen als beim Schreiben, da ich mich traue, schlampiger zu sein. Zur Vorbereitung gab es dann noch ein online multiple-choice Quiz, sowie die Möglichkeit, jederzeit anonym Fragen zu stellen via [frag.jetzt](http://frag.jetzt). Im Plenum (in Präsenz oder per Video-Konferenz) besprechen wir offene Fragen und diskutierten Aufgaben ähnlich zu [Eric Mazur's](https://mazur.harvard.edu/research-areas/peer-instruction) 
ConcepTests.  Schließlich gibt es die in der Physik üblichen Übungszettel und Kleingruppen-Übungen. Manche Übungsaufgaben und Beispiele benutzen [Julia](https://julialang.org/)  und [Pluto](https://github.com/fonsp/Pluto.jl).



Dieses Skript ist 'work in progress', und wahrscheinlich nie wirklich fertig.  Ich danke allen Studierenden des 2020er Jahrgangs, die den Text und die Gleichungen aufmerksam gelesen haben, wodurch wir viele Fehler korrigieren konnten. Trotzdem wird es noch welche geben. Wenn Sie Fehler finden, sagen Sie es mir bitte. 
Die aktuellste Version des Vorlesungsskripts finden Sie auf [github](https://github.com/MarkusLippitz/Molekuele-und-Festkoerper). Ich habe alles unter eine CC-BY-SA-Lizenz gestellt. In meinen Worten: Sie können damit machen, was Sie wollen. Wenn Sie Ihre Arbeit der Öffentlichkeit zur Verfügung stellen, erwähnen Sie mich und verwenden Sie eine ähnliche Lizenz. 


Der Text wurde mit der LaTeX-Klasse ['tufte-book'](https://tufte-latex.github.io/tufte-latex/) von Bil Kleb, Bill Wood und Kevin Godby  gesetzt, die sich der Arbeit von [Edward Tufte](https://www.edwardtufte.com/) annähert. Ich habe viele der Modifikationen angewandt, die von Dirk Eddelbüttel im R-Paket ['tint'](https://dirk.eddelbuettel.com/code/tint.html) eingeführt wurden. Die Quelle ist vorerst LaTeX, nicht Markdown.




## Struktur des Repositorys

Die Kapitel sind einzelne TeX-Dateien im Verzeichnisbaum, die per 'include' in die Haupt-TeX-Datei eingefügt werden. Die Abbildungen werden meist mit tikz erstellt. Tikz-external wird verwendet, um Kompilierungszeit zu sparen. Es generiert die pdfs im Verzeichnis 'tikz_external'. 

