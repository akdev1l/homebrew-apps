cask "xmoto" do
  version "0.6.3"
  sha256 "e40aae18c90a0f41c9cc48e63c3da278f44ba1e3328804d80d4ba0819ccc9baa"

  url "https://github.com/xmoto/xmoto/releases/download/v#{version}/xmoto-#{version}-arm64-macos.dmg",
      verified: "github.com/xmoto/xmoto/"
  name "X-Moto"
  desc "Challenging 2D motocross platform game"
  homepage "https://xmoto.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Upstream only publishes an arm64 build for macOS.
  depends_on arch: :arm64

  app "X-Moto.app"

  zap trash: [
    "~/.config/xmoto",
    "~/.local/share/xmoto",
    "~/Library/Preferences/net.sourceforge.xmoto.plist",
    "~/Library/Saved Application State/net.sourceforge.xmoto.savedState",
  ]
end
