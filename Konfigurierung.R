#Konfigurierung mit Git Hub

# (2) Git konfigurieren (Name & Mail wie auf GitHub)
usethis::use_git_config(user.name = "MaixmilianHSchumacher",
                        user.email = "maximilianhe@umass.edu")
system('git config --global user.name "MaximilianHSchumacher"')
system('git config --global user.email "maximilianhe@umass.edu"')
system('git config --global credential.helper manager')


# (3) Optional: Ein neues GitHub-Repo direkt aus RStudio heraus erstellen
use_github(private = TRUE)   # oder FALSE für öffentlich

system("git add -A")
system('git commit -m "Add Assignment3 structure (Data/Figures/Tables)"')
system("git push origin main")
