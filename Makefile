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
	mint run xcodegen  --spec project.yml

open_project: 
	open MDRF.xcodeproj

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


