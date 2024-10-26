# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-23.11"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.terraform
    pkgs.nodejs
    pkgs.nodePackages.pnpm
  ];

  # Sets environment variables in the workspace
  env = {
    GOOGLE_PROJECT = "sample-firebase-ai-app-f696f";
    CLOUDSDK_CORE_PROJECT = "sample-firebase-ai-app-f696f";
    TF_VAR_project = "sample-firebase-ai-app-f696f";
    # Flip to true to help improve Angular
    NG_CLI_ANALYTICS = "false";
    # Quieter Terraform logs
    TF_IN_AUTOMATION = "true";
  };

  idx = {
    # Search for the extensions you want on https://open-vsx.org/ and use "publisher.id"
    extensions = [
      "hashicorp.terraform"
      "angular.ng-template"
    ];

    # Enable previews
    previews = {
      enable = true;
      previews = {
        web = {
          command = [
            "ng"
            "serve"
            "--port"
            "$PORT"
          ];

          manager = "web";
        };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        default.openFiles = [
          "README.md"
          "src/services/task.service.ts"
        ];
        terraform = ''
          terraform init --upgrade
          terraform apply -parallelism=20 --auto-approve -compact-warnings
        '';
        npm = "pnpm install";
      };
      # Runs when the workspace is (re)started
      onStart = {
         terraform = ''
          terraform apply -parallelism=20 --auto-approve -compact-warnings
        '';
      };
    };
  };
}