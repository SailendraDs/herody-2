HI, Herody is a work-fullfilment platform which connects with brands offering gigs to the people as tasks to earn an extra income.

How to Run the App?

First Host Backend of the Project

Go to Azure Portal
Navigate New to Web + Mobile >> Web App
Enter App Details like Name, Location, etc and submit
Proceed to check pHP version details.
And then click extensions to add development tools and search for composer to install it
Set all the requirement parameters needed in ENV.
Now Go to Deployment Tab & Click on Deployment Options
Use the repository link and click ok. It will deploy
Add Web.Config file to the site and make necessary additions/changes.
finish it should work.
Check by adding domain to it. whether the domain.com is working or not.
Now, As the Backend is setup & running. Mobile App needs to be generated.

Install Flutter on Windows/Mac. This will install Dart along with it.
Install Android Studio - Stable
Sign all required Android Licenses
Run flutter doctor -v to see whether all conditions are met. if not check to do it.
To run this App, You will need to use Flutter Master [Any version]
Open Visual Studio Code [If you're not aware of using in Android Studio]
Open New Terminal & Enter flutter clean
It clears all the cached files & provides clean app.
Now, run flutter build apk --release
This command will generate fresh release apk to submit on playstore. but the recommended file to push to playstore is Bundle.
Bundle helps in supporting all the android devices.
So, run flutter build appbundle ~ this command generates app bundle
That's it.

Configuration:

Backend is built on Laravel (PHP Framework). It contains:

Truecaller, Google & Email Based Authentication Routes.
We used Telecalling APIs provided by MyOperator which tracks every call.
We used SMS services and Email Services from Sendgrid, Twilio, Firebase, etc.
Also Image Upload Services is done with native codes.
Frontend is built on Bootstrap where Admin & Brand can access the website to post Gigs, Projects & Campaigns. There's a Mobile App which is developed on Flutter. This contains:

Razorpay Payout is connected to the user's wallet to enable instant withdrawals from App.
My Operator is also connected here to facilitate telecalling projects track calls instantly.
That's all. Thank you.Add your source code to this directory. Please don't rename this directory.
