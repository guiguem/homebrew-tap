# Guiguem Tap

## How do I install these formulae?

`brew install guiguem/tap/<formula>`

Or `brew tap guiguem/tap` and then `brew install <formula>`.

Or, in a [`brew bundle`](https://github.com/Homebrew/homebrew-bundle) `Brewfile`:

```ruby
tap "guiguem/tap"
brew "<formula>"
```

## Add a new formula

```bash
brew create --cmake https://<URL>/<package>.git --tap guiguem/tap --set-version <version>
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
