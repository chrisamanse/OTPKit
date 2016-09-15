import PackageDescription

let package = Package(
    name: "OTPKit",
    dependencies: [
        .Package(url: "https://github.com/chrisamanse/CryptoKit.git", 
majorVersion: 0)
    ]
)
