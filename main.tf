terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs#github-app-installation
provider "github" {
  owner = "satake-test" # org name
  app_auth {
    id              = "793659"
    installation_id = "45994882"
    pem_file        = file("./satake-org-terraform.private-key.pem")
  }
}

resource "github_membership" "satake" {
  username = "isSatake"
  role     = "admin"
}

resource "github_team" "root-team" {
  name    = "root-team"
  privacy = "closed" # visible to all members of this organization.
}

resource "github_team_members" "root-team-members" {
  team_id = github_team.root-team.id

  members {
    username = "isSatake"
    role     = "member"
  }
}

resource "github_team" "child-team" {
  name           = "child-team"
  parent_team_id = github_team.root-team.id
  privacy        = "closed"
}
