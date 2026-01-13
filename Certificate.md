# Changing Distribution Certificate iOS MGO

To export your Apple Distribution Certificate, use the Keychain Access app on your Mac, find the certificate (e.g., "iPhone Distribution: Your Company Name") in "My Certificates," right-click, and choose Export to save it as a password-protected .p12 file, which includes the crucial private key needed for signing apps. 

Step-by-Step Guide:

1. Go to [Certificates Overview](https://developer.apple.com/account/resources/certificates/list)

2. Click on the + sign

3. Select Apple Distribution from the Create a New Certificate options and press continue

4. Open Keychain Access: Go to Applications > Utilities > Keychain Access on your Mac.

5. From the Keychain Access menu, select Certificate Assistant. 
   1. Select open.

   2. Press Continue

   3. Select Request a certificate from an existing CA, press continue

   4. Use your apple id for User Email Address

   5. Use your name for Common Name

   6. Leave CA Email address empty

   7. Select saved to disk and save the CertificateSigningRequest.certSigningRequest

6. Go back to the browser and upload the CertificateSigningRequest.certSigningRequest to Create a new Certificate

7. Download the newly created certificate to your device. 

8. Install the certificate into KeyChain Access by opening the certificate. 

9. Select the Right Keychain: In the left sidebar, select the login keychain, then choose My Certificates under Categories.

10. Locate Your Certificate: Find your distribution certificate, usually named "iPhone Distribution: Your Company Name" or "Apple Distribution: Your Company Name".

11. Expand & Select: Click the small arrow next to the certificate to expand it, then select both the certificate and its associated private key (the one with the key icon).

12. Export Items: Right-click (or Control-click) the selected items and choose Export 2 items... or Export "Your Certificate Name...".

13. Save as .p12:
    1. Choose a location and name for your file (e.g., DistributionCert.p12).

    2. Ensure the File Format is set to Personal Information Exchange (.p12) (this includes the private key).

    3. Click Save.

14. Set a Password: You'll be prompted to create a password to protect the .p12 file. Choose a strong one and save it securely, as you'll need it to import the certificate on other machines.

15. Enter Computer Password: You might need to enter your Mac's user password to authorize the export. 

16. You now have a .p12 file containing your certificate and private key, ready to be imported into Xcode or another machine for app signing.

17. Locate your .p12 file in the terminal and run `cat [certificateName] | base64 > [certificateName].b64` 

18. Go to [Github Secrets](https://github.com/minvws/nl-mgo-app-ios-private/settings/secrets/actions) and update the DIST_CERT_CONTENTS with the content of the .b64 file, and update DIST_CERT_PASSWORD with the password from step 14

19. Update the [Provisioning Profiles](https://developer.apple.com/account/resources/profiles/list) with the new certificate.

