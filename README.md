# OTPKit

OTPKit is a Swift framework containing implementations of one-time password algorithms.

**Supported Algorithms**

- [x] [HOTP (HMAC-based One-time Password Algorithm)](https://tools.ietf.org/html/rfc4226)
- [x] [TOTP (Time-based One-time Password Algorithm)](https://tools.ietf.org/html/rfc6238)

# Usage

## Generating a time-based one-time password

```swift

// Shared unique secret (usually represented by a Base 32 string)
let base32String = "V3ZMBGAETLLSXRJZ6QZD42Z33O3DK3R7"

let secret = try! Base32.decode(base32String)

let passwordGenerator = TOTPGenerator(key: secret, period: 30, digits: 6, hashFunction: .sha1)

let now = Date()
try? passwordGenerator.password(for: now) // Password for current time
try? passwordGenerator.password(for: now + 30) // Password for 30 seconds from now

```

# License

Copyright (c) 2016 Joe Christopher Paul Amanse

This software is distributed under the [MIT License](./LICENSE).
