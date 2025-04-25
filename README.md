# kerberos-tools
A collection of scripts and tools for dealing with Kerberos

## Index

- **`make_custom_krb5_conf.sh`**

## Scripts

### make_custom_krb5_config

Just input the fully-qualified-domain-name of the KDC, and it will spit out a Kerberos configuration file for your target.

> :pray: All credit goes to [0xBEN (Ben Heater)](https://notes.benheater.com/books/active-directory/page/kerberos-authentication-from-kali) for providing the bash command that I modified into this script. All I did was streamline it a little. Consider [donating to them](https://notes.benheater.com/books/contribute/page/have-i-helped-you-today).

```
Usage: ./make_custom_krb5_conf.sh [options]
  -K, --kdc-fqdn       <FQDN>         (Required) FQDN for the KDC, ex dc01.whatever.lol
  -o, --output-file    <output file>  (Optional) Filepath for output (default: custom_kerb5.config)
```

---

> I hope you all get as much use out of this as I do :heart: If you enjoy this repo, please give it a :star:

Enjoy,

:handshake::handshake::handshake::handshake:
@4wayhandshake
