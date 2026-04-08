# CI/CD

## Core CI/CD & Testing                                                                                                         

  - ci.yml (Main Pipeline):                                                                                                       
    - Triggers: push to main and pull_request (opened, synchronized, reopened).                                                   
    - Process: Pre-starts an iPhone 17 Pro simulator, sets up Homebrew and Mint dependencies, runs SwiftLint, generates the Xcode
      project (make generate_project), and executes unit tests via fastlane ios test_ci.                                              
    - Artifacts: It converts xccov results to a SonarQube-compatible format and uploads coverage.xml.                           
    - SonarCloud: A secondary job runs on ubuntu-24.04 to perform a SonarQube scan using the uploaded coverage data.              
  - e2e.yml (End-to-End Testing):                                                                                                 
    - Triggers: Scheduled (every Thursday at 04:10 UTC) and workflow_dispatch.                                                    
    - Process: Similar setup to CI (simulator, Homebrew, project generation). It sets the timezone to Europe/Amsterdam and runs   
      end-to-end tests via fastlane ios e2e_ci.                                                                                       
    - Artifacts: Archives test output and .xcresult logs.                                                                         
                                                                                                                                  
## Deployment Workflows                                                                                                         

  - Firebase Deployment (Manual & Auto):                                                                                          
    - deploy-firebase-manual.yml: Allows manual triggering (workflow_dispatch) to deploy specific environments (test, acc, or     
      prod) by passing boolean inputs.                                                                                                
    - deploy-firebase-merge.yml: Automatically deploys to Firebase when changes are pushed to main or release/* branches.         
    - template_firebase-deploy.yml: A reusable workflow used by both the manual and auto workflows to standardize the deployment
      process (certificate loading, project generation, and running specific fastlane commands).                                      
  - deploy-testflight.yml (App Store/TestFlight):                                                                               
    - Triggers: Pushes to tags matching Release-*.*.*-RC* and workflow_dispatch.                                                  
    - Process: Logs build numbers, sets up the environment, handles Apple Store API keys (p8), loads distribution certificates,   
      and uses fastlane ios ship_app_to_testflight to upload the build.                                                               
    - Artifacts: Archives the .ipa and .dSYM files.                                                                               
                                                                                                                                  
## Quality & Compliance                                                                                                         

  - lint-pr.yml: Validates that Pull Request titles follow semantic conventions using amannn/action-semantic-pull-request.        
  - reuse-lint.yml: A specialized check to ensure the repository complies with REUSE standards (for managing licensing and        
  metadata).                                                                                                                      
                                                                                                                                  
## Summary (Bulleted)

- ci.yml
  - Purpose: Build, test, coverage, and SonarCloud analysis.
  - Triggers: push (main), pull_request (opened, synchronized, reopened).
  - Key commands: `fastlane ios test_ci`; converts xccov to SonarQube format and uploads `coverage.xml`.
  - Artifacts: `coverage.xml`; consider also archiving `.xcresult` for debugging.
- e2e.yml
  - Purpose: End-to-end tests on a pre-booted simulator.
  - Triggers: schedule (Thu 04:10 UTC), workflow_dispatch.
  - Key commands: `fastlane ios e2e_ci` with timezone set to Europe/Amsterdam (for deterministic time-based tests).
  - Artifacts: Archives test output and `.xcresult` logs (note retention policy if applicable).
- deploy-firebase-*
  - Purpose: Firebase App Distribution (manual and automatic).
  - Triggers: push (main/release/*), workflow_dispatch.
  - Key commands: `fastlane ios deploy_*_ci`; uses reusable template for certificate loading and project generation.
- deploy-testflight.yml
  - Purpose: TestFlight uploads.
  - Triggers: tags `Release-*.*.*-RC*`, workflow_dispatch.
  - Key commands: `fastlane ios ship_app_to_testflight`.
  - Artifacts: Archives `.ipa` and `.dSYM`.
- lint-pr.yml
  - Purpose: PR title validation (semantic conventions).
  - Triggers: pull_request.
- reuse-lint.yml
  - Purpose: REUSE license compliance checks.
  - Triggers: pull_request.

## Related Documents

- [Certificate.md](Certificate.md): Code signing and certificate management details referenced by deployment workflows.

## Fastlane Lanes (Appendix)

- test_ci: Runs unit tests with xcodebuild, produces coverage for SonarCloud.
- e2e_ci: Runs UI/E2E tests on a pre-booted simulator; archives `.xcresult`.
- deploy_test_ci / deploy_acc_ci / deploy_prod_ci: Distributes builds to Firebase App Distribution for the respective environments.
- ship_app_to_testflight: Builds and uploads to TestFlight; archives `.ipa` and `.dSYM`.

## SonarCloud and Secrets

- The SonarCloud analysis runs as a separate Ubuntu job that depends on the coverage artifact uploaded by the macOS CI job.
- Required repository secrets (names may vary based on your setup):
  - `SONAR_TOKEN`
  - `SONAR_PROJECT_KEY`
- Ensure the CI job uploads `coverage.xml` to a known path and that the Sonar job downloads it before invoking the scanner.

