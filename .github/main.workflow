workflow "Build and Deploy" {
  on = "push"

  resolves = [
    "deploy api-domains-cdn-controller",
    "deploy api-integrations",
    "deploy api-projects",
    "deploy api-upload",
    "deploy integrations-worker",
    "deploy now-encryption-key-rotator",
    "deploy now-registration",
    "deploy team-seat-sync",
  ]
}

# DOCKER BUILD

action "docker build api-upload" {
  uses    = "./actions/docker/cli"
  secrets = ["NPM_AUTH_TOKEN"]

  args = [
    "build",
    "--build-arg",
    "NPM_TOKEN=$NPM_AUTH_TOKEN",
    "--build-arg",
    "IMAGE_RELEASE_VERSION=$(echo $GITHUB_REF | cut -f3 -d'/')",
    "-t",
    "api-upload",
    "./services/api-upload",
  ]
}

action "docker build api-domains-cdn-controller" {
  uses    = "zeit/actions/docker/cli@master"
  secrets = ["NPM_AUTH_TOKEN"]

  args = [
    "build",
    "--build-arg",
    "NPM_TOKEN=$NPM_AUTH_TOKEN",
    "--build-arg",
    "IMAGE_RELEASE_VERSION=$(echo $GITHUB_REF | cut -f3 -d'/')",
    "-t",
    "api-domains-cdn-controller",
    "./services/api-domains-cdn-controller",
  ]
}

action "docker build api-projects" {
  uses    = "zeit/actions/docker/cli@master"
  secrets = ["NPM_AUTH_TOKEN"]

  args = [
    "build",
    "--build-arg",
    "NPM_TOKEN=$NPM_AUTH_TOKEN",
    "--build-arg",
    "IMAGE_RELEASE_VERSION=$(echo $GITHUB_REF | cut -f3 -d'/')",
    "-t",
    "api-projects",
    "./services/api-projects",
  ]
}

action "docker build api-integrations" {
  uses    = "zeit/actions/docker/cli@master"
  secrets = ["NPM_AUTH_TOKEN"]

  args = [
    "build",
    "--build-arg",
    "NPM_TOKEN=$NPM_AUTH_TOKEN",
    "--build-arg",
    "IMAGE_RELEASE_VERSION=$(echo $GITHUB_REF | cut -f3 -d'/')",
    "-t",
    "integration-controller",
    "./services/api-integrations",
  ]
}

action "docker build integrations-worker" {
  uses    = "zeit/actions/docker/cli@master"
  secrets = ["NPM_AUTH_TOKEN"]

  args = [
    "build",
    "--build-arg",
    "NPM_TOKEN=$NPM_AUTH_TOKEN",
    "--build-arg",
    "IMAGE_RELEASE_VERSION=$(echo $GITHUB_REF | cut -f3 -d'/')",
    "-t",
    "integration-worker",
    "./services/integrations-worker",
  ]
}

action "docker build now-encryption-key-rotator" {
  uses    = "zeit/actions/docker/cli@master"
  secrets = ["NPM_AUTH_TOKEN"]

  args = [
    "build",
    "--build-arg",
    "NPM_TOKEN=$NPM_AUTH_TOKEN",
    "--build-arg",
    "IMAGE_RELEASE_VERSION=$(echo $GITHUB_REF | cut -f3 -d'/')",
    "-t",
    "now-encryption-key-rotator",
    "./services/now-encryption-key-rotator",
  ]
}

action "docker build now-registration" {
  uses    = "zeit/actions/docker/cli@master"
  secrets = ["NPM_AUTH_TOKEN"]

  args = [
    "build",
    "--build-arg",
    "NPM_TOKEN=$NPM_AUTH_TOKEN",
    "--build-arg",
    "IMAGE_RELEASE_VERSION=$(echo $GITHUB_REF | cut -f3 -d'/')",
    "-t",
    "now-registration",
    "./services/now-registration",
  ]
}

action "docker build team-seat-sync" {
  uses    = "zeit/actions/docker/cli@master"
  secrets = ["NPM_AUTH_TOKEN"]

  args = [
    "build",
    "--build-arg",
    "NPM_TOKEN=$NPM_AUTH_TOKEN",
    "--build-arg",
    "IMAGE_RELEASE_VERSION=$(echo $GITHUB_REF | cut -f3 -d'/')",
    "-t",
    "team-seat-sync",
    "./loops/team-seat-sync/",
  ]
}

# TAGGING AND FILTERING

action "tag filter" {
  needs = [
    "docker build api-domains-cdn-controller",
    "docker build api-integrations",
    "docker build api-projects",
    "docker build api-upload",
    "docker build integrations-worker",
    "docker build now-encryption-key-rotator",
    "docker build now-registration",
    "docker build team-seat-sync",
  ]

  uses = "actions/bin/filter@master"
  args = "tag"
}

action "docker tag api-upload" {
  needs = ["tag filter"]
  uses  = "zeit/actions/docker/tag@master"
  args  = ["api-upload", "gcr.io/zeit-main/api-upload", "--no-sha", "--no-latest"]
}

action "docker tag api-domains-cdn-controller" {
  needs = ["tag filter"]
  uses  = "zeit/actions/docker/tag@master"
  args  = ["api-domains-cdn-controller", "gcr.io/zeit-main/api-domains-cdn-controller", "--no-sha", "--no-latest"]
}

action "docker tag api-projects" {
  needs = ["tag filter"]
  uses  = "zeit/actions/docker/tag@master"
  args  = ["api-projects", "gcr.io/zeit-main/api-projects", "--no-sha", "--no-latest"]
}

action "docker tag api-integrations" {
  needs = ["tag filter"]
  uses  = "zeit/actions/docker/tag@master"
  args  = ["integration-controller", "gcr.io/zeit-main/integration-controller", "--no-sha", "--no-latest"]
}

action "docker tag integrations-worker" {
  needs = ["tag filter"]
  uses  = "zeit/actions/docker/tag@master"
  args  = ["integration-worker", "gcr.io/zeit-main/integration-worker", "--no-sha", "--no-latest"]
}

action "docker tag now-encryption-key-rotator" {
  needs = ["tag filter"]
  uses  = "zeit/actions/docker/tag@master"
  args  = ["now-encryption-key-rotator", "gcr.io/zeit-main/now-encryption-key-rotator", "--no-sha", "--no-latest"]
}

action "docker tag now-registration" {
  needs = ["tag filter"]
  uses  = "zeit/actions/docker/tag@master"
  args  = ["now-registration", "gcr.io/zeit-main/now-registration", "--no-sha", "--no-latest"]
}

action "docker tag team-seat-sync" {
  needs = ["tag filter"]
  uses  = "zeit/actions/docker/tag@master"
  args  = ["team-seat-sync", "gcr.io/zeit-main/team-seat-sync", "--no-sha", "--no-latest"]
}

action "gcloud auth" {
  needs   = ["tag filter"]
  uses    = "actions/gcloud/auth@master"
  secrets = ["GCLOUD_AUTH"]
}

action "gcloud docker auth" {
  needs = ["tag filter"]
  uses  = "actions/gcloud/cli@master"
  args  = ["auth", "configure-docker", "--quiet"]
}

# DOCKER PUSH

action "docker push api-upload" {
  needs = [
    "docker tag api-upload",
    "gcloud auth",
    "gcloud docker auth",
  ]

  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  args = ["docker push gcr.io/zeit-main/api-upload"]
}

action "docker push api-domains-cdn-controller" {
  needs = [
    "docker tag api-domains-cdn-controller",
    "gcloud auth",
    "gcloud docker auth",
  ]

  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  args = ["docker push gcr.io/zeit-main/api-domains-cdn-controller"]
}

action "docker push api-projects" {
  needs = [
    "docker tag api-projects",
    "gcloud auth",
    "gcloud docker auth",
  ]

  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  args = ["docker push gcr.io/zeit-main/api-projects"]
}

action "docker push api-integrations" {
  needs = [
    "docker tag api-integrations",
    "gcloud auth",
    "gcloud docker auth",
  ]

  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  args = ["docker push gcr.io/zeit-main/integration-controller"]
}

action "docker push integrations-worker" {
  needs = [
    "docker tag integrations-worker",
    "gcloud auth",
    "gcloud docker auth",
  ]

  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  args = ["docker push gcr.io/zeit-main/integration-worker"]
}

action "docker push now-encryption-key-rotator" {
  needs = [
    "docker tag now-encryption-key-rotator",
    "gcloud auth",
    "gcloud docker auth",
  ]

  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  args = ["docker push gcr.io/zeit-main/now-encryption-key-rotator"]
}

action "docker push now-registration" {
  needs = [
    "docker tag now-registration",
    "gcloud auth",
    "gcloud docker auth",
  ]

  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  args = ["docker push gcr.io/zeit-main/now-registration"]
}

action "docker push team-seat-sync" {
  needs = [
    "docker tag team-seat-sync",
    "gcloud auth",
    "gcloud docker auth",
  ]

  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  args = ["docker push gcr.io/zeit-main/team-seat-sync"]
}

# DEPLOY

action "deploy api-domains-cdn-controller" {
  needs = ["docker push api-domains-cdn-controller"]
  uses  = "docker://zeit/deploy-k8s-slack-action"

  secrets = [
    "SLACK_BOT_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "KUBE_CONFIG_URL",
    "KUBE_CONFIG_PWD",
  ]

  env = {
    SLACK_CHANNEL = "#defcon"
    DEPLOYMENT    = "api-domains-cdn-controller"
    YAML_PATH     = "services/api-domains-cdn-controller/app.yaml"
    CONTEXTS      = "bru1 gru1 iad1 hnd1 sfo1"
  }
}

action "deploy api-upload" {
  needs = ["docker push api-upload"]
  uses  = "docker://zeit/deploy-k8s-slack-action"

  secrets = [
    "SLACK_BOT_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "KUBE_CONFIG_URL",
    "KUBE_CONFIG_PWD",
  ]

  env = {
    SLACK_CHANNEL = "#defcon"
    DEPLOYMENT    = "api-upload"
    YAML_PATH     = "services/api-upload/app.yaml"
    CONTEXTS      = "bru1 gru1 iad1 hnd1 sfo1"
  }
}

action "deploy api-projects" {
  needs = ["docker push api-projects"]
  uses  = "docker://zeit/deploy-k8s-slack-action"

  secrets = [
    "SLACK_BOT_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "KUBE_CONFIG_URL",
    "KUBE_CONFIG_PWD",
  ]

  env = {
    SLACK_CHANNEL = "#defcon"
    DEPLOYMENT    = "api-projects"
    YAML_PATH     = "services/api-projects/app.yaml"
    CONTEXTS      = "bru1 sfo1"
  }
}

action "deploy api-integrations" {
  needs = ["docker push api-integrations"]
  uses  = "docker://zeit/deploy-k8s-slack-action"

  secrets = [
    "SLACK_BOT_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "KUBE_CONFIG_URL",
    "KUBE_CONFIG_PWD",
  ]

  env = {
    SLACK_CHANNEL = "#defcon"
    DEPLOYMENT    = "integration-controller"
    YAML_PATH     = "services/api-integrations/app.yaml"
    CONTEXTS      = "bru1 sfo1"
  }
}

action "deploy integrations-worker" {
  needs = ["docker push integrations-worker"]
  uses  = "docker://zeit/deploy-k8s-slack-action"

  secrets = [
    "SLACK_BOT_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "KUBE_CONFIG_URL",
    "KUBE_CONFIG_PWD",
  ]

  env = {
    SLACK_CHANNEL = "#defcon"
    DEPLOYMENT    = "integration-worker"
    YAML_PATH     = "services/integrations-worker/app.yaml"
    CONTEXTS      = "sfo1"
  }
}

action "deploy now-encryption-key-rotator" {
  needs = ["docker push now-encryption-key-rotator"]
  uses  = "docker://zeit/deploy-k8s-slack-action"

  secrets = [
    "SLACK_BOT_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "KUBE_CONFIG_URL",
    "KUBE_CONFIG_PWD",
  ]

  env = {
    SLACK_CHANNEL = "#defcon"
    DEPLOYMENT    = "now-encryption-key-rotator"
    YAML_PATH     = "services/now-encryption-key-rotator/app.yaml"
    CONTEXTS      = "bru1 hnd1 iad1 sfo1 gru1"
  }
}

action "deploy now-registration" {
  needs = ["docker push now-registration"]
  uses  = "docker://zeit/deploy-k8s-slack-action"

  secrets = [
    "SLACK_BOT_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "KUBE_CONFIG_URL",
    "KUBE_CONFIG_PWD",
  ]

  env = {
    SLACK_CHANNEL = "#defcon"
    DEPLOYMENT    = "now-registration"
    YAML_PATH     = "services/now-registration/app.yaml"
    CONTEXTS      = "bru1 sfo1"
  }
}

action "deploy team-seat-sync" {
  needs = ["docker push team-seat-sync"]
  uses  = "docker://zeit/deploy-k8s-slack-action"

  secrets = [
    "SLACK_BOT_TOKEN",
    "AWS_ACCESS_KEY_ID",
    "AWS_SECRET_ACCESS_KEY",
    "KUBE_CONFIG_URL",
    "KUBE_CONFIG_PWD",
  ]

  env = {
    SLACK_CHANNEL = "#defcon"
    DEPLOYMENT    = "team-seat-sync"
    CONTEXTS      = "sfo1"
    YAML_PATH     = "loops/team-seat-sync/app.yaml"
  }
}

# OTHER

workflow "@zeit/now-routing-utils" {
  on       = "push"
  resolves = ["Build and Test @zeit/now-routing-utils"]
}

action "Build and Test @zeit/now-routing-utils" {
  uses    = "zackify/npm@354aa07c3dc1f17f66afa69d1ddaac4620dc0668"
  args    = "cd utils/now-routing-utils && npm install && npm run lint && npm run coverage && npm run report"
  secrets = ["CODECOV_TOKEN"]
}
