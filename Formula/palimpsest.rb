class Palimpsest < Formula
  desc "Persistent memory layer for Claude Code & GitHub Copilot, built on Obsidian"
  homepage "https://github.com/Sokrix/palimpsest"
  url "https://github.com/Sokrix/palimpsest/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "d2e4a995cdc1d1cd1ef392a5a5c087d17b754c5dac835e893caca6f5d6fbeed3"
  license "Apache-2.0"

  depends_on "python@3"
  depends_on :macos

  def install
    # Ship the runtime tree under libexec/ so the CLI can find it via
    # PALIMPSEST_HOME_OVERRIDE without polluting share/.
    libexec.install "templates", "lib", "install.sh", "VERSION"

    # The CLI itself goes in bin/. Bake the libexec path into the script so
    # it doesn't need to probe at runtime.
    bin.install "bin/palimpsest"
    inreplace bin/"palimpsest",
              'PALIMPSEST_HOME_OVERRIDE=""',
              "PALIMPSEST_HOME_OVERRIDE=\"#{libexec}\""

    # Shell completions (auto-loaded by Homebrew's shell hooks).
    zsh_completion.install "completions/_palimpsest"
    bash_completion.install "completions/palimpsest.bash" => "palimpsest"
  end

  def caveats
    <<~EOS
      Next steps:
        1. Run the interactive setup:    palimpsest install
        2. Health-check the install:     palimpsest doctor
        3. List all commands:            palimpsest help

      Tab-completion (zsh + bash) is installed automatically.
      For zsh, restart your shell or run `compinit` to pick it up.
    EOS
  end

  test do
    assert_match(/^palimpsest v\d+\.\d+\.\d+/, shell_output("#{bin}/palimpsest version"))
    assert_match "Usage: palimpsest", shell_output("#{bin}/palimpsest help")
  end
end
