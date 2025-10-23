#Mein erstes script
# (1) Deinen GitHub-Token sicher speichern
gitcreds::gitcreds_set()

# (2) Git konfigurieren (Name & Mail wie auf GitHub)
usethis::use_git_config(user.name = "MaixmilianHSchumacher",
                        user.email = "maximilianhe@umass.edu")

# (3) Optional: Ein neues GitHub-Repo direkt aus RStudio heraus erstellen
use_github(private = TRUE)   # oder FALSE für öffentlich

dir.create("Assignment3/Data", recursive = TRUE)
dir.create("Assignment3/Figures", recursive = TRUE)
dir.create("Assignment3/Tables", recursive = TRUE)

writeLines("Data folder for Assignment 3", "Assignment3/Data/README.md")
writeLines("Figures for Assignment 3", "Assignment3/Figures/README.md")
writeLines("Tables for Assignment 3", "Assignment3/Tables/README.md")

system("git add -A")
system('git commit -m "Add Assignment3 structure (Data/Figures/Tables)"')
system("git push origin main")
