# -- Main entrypoint

dev: install_dev_deps install_githooks generate_project open_project

# -- Setup Environment --

install_dev_deps: homebrew_dev bundler mint
	@echo "All dev dependencies are installed"

# -- -- Homebrew
homebrew_dev:
ifeq (, $(shell which brew))
$(error "You must install homebrew on your system before setup can continue. Visit: https://brew.sh to get started with that.")
endif
	@brew bundle --file Brewfile

homebrew_ci:
	@brew bundle --file Brewfile_CI

homebrew_ci_imagemagick: # only needed for specific context & takes time, so not adding to Brewfile_CI.
	@brew install imagemagick

# -- -- Ruby

bundler: 
ifeq (, $(shell which bundle))
$(error "You must install bundler on your system before setup can continue. You could try running 'gem install bundler'.")
endif
	bundle config set --local path 'vendor/bundle'
	bundle install

# -- -- SPM

mint:
	@mint bootstrap --mintfile ./Mintfile

mint_ci:
	@mint bootstrap --mintfile ./Mintfile_CI

# -- -- Generate Xcode project -- 

generate_project: 
	mint run xcodegen --spec project.yml

open_project: 
	open MGO.xcodeproj

# -- Linting -- 

run_swiftlint:
	mint run swiftlint --quiet --strict --config=./.swiftlint.yml
	
# -- Install Git Hooks: -- 

install_githooks: install_githooks_gitlfs install_githooks_xcodegen
	@echo "All githooks are installed"

install_githooks_xcodegen:
	@echo "\nxcodegen generate --spec project.yml --use-cache" >> .git/hooks/post-checkout
	@chmod +x .git/hooks/post-checkout

install_githooks_gitlfs:
	@git lfs install --force

# -- Generating Diagrams --

generate_diagrams:
	@d2 Diagrams/packages-testonly.d2 Diagrams/packages-testonly.png --layout=elk
	@d2 Diagrams/packages-withouttests.d2 Diagrams/packages-withouttests.png --layout=elk
	@d2 Diagrams/legenda.d2 Diagrams/legenda.png --layout=elk
	@d2 Diagrams/scripts.d2 Diagrams/scripts.png --layout=elk

download_translations:
	@mkdir -p tmp/localization_downloads
	@lokalise2 file download --token ${LOKALISE_API_KEY} --project-id "61099271667adf7aa39e27.29068045" --format strings --original-filenames false --unzip-to tmp/localization_downloads/ --export-sort a_z --export-empty-as skip --placeholder-format ios
	@cd Packages/CopyImport/ && swift run CopyImport --source-path ../../tmp/localization_downloads/nl.lproj/Localizable.strings --target-path ../../tmp/localization_downloads/Localizable.xcstrings
	@rm -f ./Sources/MGO/Resources/Localizable.xcstrings
	@cp ./tmp/localization_downloads/Localizable.xcstrings ./Sources/MGO/Resources/Localizable.xcstrings
	@rm -rf "tmp/localization_downloads"
	
import_sharedcore:
	@mkdir -p tmp/sharedcore
	
	# Download
	@cd Packages/GithubArtifactDownload/ && swift run GithubArtifactDownload --token ${GITHUB_API_KEY} --owner "minvws" --repository "nl-mgo-app-web-private" --workflow-id "114414377" --output ../../tmp/sharedcore/artifact.zip
	
	# Unpack
	@cd tmp/sharedcore && unzip artifact.zip
	@cd tmp/sharedcore && mv *.tar.gz artifact.tar.gz && tar -xzvf artifact.tar.gz
	
	# Move Files
	@rm -f packages/SharedCore/Sources/SharedCore/Resources/version.json && cp tmp/sharedcore/version.json packages/SharedCore/Sources/SharedCore/Resources/version.json
	@rm -f packages/SharedCore/Sources/SharedCore/Resources/*.js && cp tmp/sharedcore/js/* packages/SharedCore/Sources/SharedCore/Resources/
	
#	@rm -f packages/SharedCore/Sources/SharedCore/Zibs/Generated/* && cp tmp/sharedcore/schema/swift/* packages/SharedCore/Sources/SharedCore/Zibs/Generated/

	# Generate Zibs from schema/json/types.json
	@rm -f packages/SharedCore/Sources/SharedCore/Zibs/Generated/*
	@quicktype --src "./tmp/sharedcore/schema/json/types.json#/definitions/" --src-lang schema --access-level public --protocol hashable --sendable --multi-file-output --out ./Packages/SharedCore/Sources/SharedCore/Zibs/Generated/Types.swift --swift-5-support

	# Cleanup
	@rm -rf "tmp/sharedcore"
