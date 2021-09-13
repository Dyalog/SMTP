# SMTP

`SMTP` allows you to send emails from within Dyalog APL.

The package comes with a ready-to-go example that works out of the box.


1. Install the package with 

   ```
   ]TATIN.LoadPackage [tatin]SMTP
   ```

2. Send an email with 

   ```
   SMTP.SendEmailExample 'john.doe@whatever.com'
   ```

Note that the example uses a particular email address and password that can be accessed by anybody who loads the package. Of course this means that you must not send anything remotely confidential to this email address as clear text.

This address is configured so that an application can kind of log on with that password, and then send emails to that address; this is considered relatively unsafe.

It cannot be used for spam because the number of emails one can send this way is severly limited by Google, but it can be used to send test mails.

Nobody is watching that email address, but the _real_ receiver is the CC anyway of course.

You may create your own email address with Google and use it to send messages from a server for reporting...

* Crashes
* "Start" and "Shutdown" events

If you need to make sure that nobody can decipher any mail you are going to send this way then you must first encrypt the body and possibly any attachments as well.

Further information is available by loading the package and then calling the `Help` method.