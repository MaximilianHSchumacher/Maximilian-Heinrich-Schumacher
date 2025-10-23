#Mein erstes script

install.packages(c("usethis", "gitcreds", "gh"))
library(usethis)
library(gitcreds)

# (1) Deinen GitHub-Token sicher speichern
gitcreds::gitcreds_set()

# (2) Git konfigurieren (Name & Mail wie auf GitHub)
usethis::use_git_config(user.name = "MaixmilianHSchumacher",
                        user.email = "maximilianhe@umass.edu")

# (3) Optional: Ein neues GitHub-Repo direkt aus RStudio heraus erstellen
use_github(private = TRUE)   # oder FALSE für öffentlich