terraform {
  backend "s3" {
    bucket = "satake-test-terraform-state"
    key    = "test-github-terraform/terraform.tfstate"
    region = "us-west-2"
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

variable "github_app_id" {
  type = string
}

variable "github_app_installation_id" {
  type = string
}

variable "github_app_pem_file" {
  type = string
}

provider "github" {
  owner = "satake-test"
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = var.github_app_pem_file
  }
}

resource "github_membership" "satake" {
  role     = "admin"
  username = "isSatake"
}

resource "github_team" "root-team" {
  name    = "root-team"
  privacy = "closed"
}

resource "github_team_members" "root-team-members" {
  team_id = github_team.root-team.id
  members {
    role     = "maintainer"
    username = "isSatake"
  }
}

resource "github_team" "child-team" {
  name           = "child-team"
  privacy        = "closed"
  parent_team_id = github_team.root-team.id
}

resource "github_team_members" "child-team-members" {
  team_id = github_team.child-team.id
  members {
    role     = "maintainer"
    username = "isSatake"
  }
}

resource "github_team" "grandchild-team" {
  name           = "grandchild-team"
  privacy        = "closed"
  parent_team_id = github_team.child-team.id
}

resource "github_team_members" "grandchild-team-members" {
  team_id = github_team.grandchild-team.id
  members {
    role     = "maintainer"
    username = "isSatake"
  }
}
