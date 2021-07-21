﻿ (rc msg server)←serverArgs SendMail messageArgs;⎕ML;⎕IO;params;msgParams;log;server
 ⍝ Simple cover to send SMTP mail
 ⍝ Requires: SMTP class

 ⍝ rc   - return code; 0=no error, 1=error from the SMTP server, anything else=other error
 ⍝ msg  - descriptive message
 ⍝ server - reference to instance of SMTP (only returned when serverArgs is the server definition)


 ⍝ serverArgs is one of:
 ⍝ A server definition in one of the following formats:
 ⍝   ∘ a vector of Server Port From [Password [Userid [Secure]]]
 ⍝   ∘ a namespace containing required named elements: Server Port From
 ⍝     and optionally Password Userid Secure plus any other parameters applicable to the SMTP class
 ⍝ Or
 ⍝   ∘ an instance of the SMTP class created by SendMail

 ⍝ messageArgs is one of:
 ⍝ ∘ a vector of To Subj Body
 ⍝ ∘ a namespace containing required named elements: To Subj Body
 ⍝     and optionally any other parameters applicable to the SMTP.Message class

 ⍝ Once the SMTP server instance has been created, it is passed as the left argument
 ⍝ in subsequent calls to Sendmail

 ⍝ Examples:
 ⍝ (srv←⎕NS'').(Server Port From Password)←'mail.abc.com' 465 'me@abc.com' 'secret'
 ⍝ Server←3⊃srv SendMail '' ⍝ create the server instance
 ⍝ (msg←⎕NS'').(To Subj Body)←'you@xyz.com' 'Hello' 'Hi there!'
 ⍝ Server SendMail msg
 ⍝
 ⍝ The server can be created and message sent in a single call:
 ⍝ Server←3⊃srv SendMail msg

 ⎕IO←⎕ML←1

 (rc msg server)←¯1 'Nothing done' ''
 params←0
 :Select ⎕NC⊂'serverArgs'
 :Case 2.1 ⋄ params←⎕NS'' ⋄ params.(Server Port From Password Userid Secure)←''⍬'' '' '' ¯1{(≢⍺)↑⍵,⍺↓⍨≢⍵},⊆serverArgs
 :Case 9.1 ⋄ params←serverArgs
 :Case 9.2 ⋄ server←serverArgs
 :Case 0 ⍝ not defined? do nothing
 :Else ⋄ →Exit⊣(rc msg)←¯1 'Invalid serverArgs' ⍝ paranoia
 :EndSelect

 :If params≢0
     :Trap 0 ⋄ server←⎕NEW SMTP params
     :Else ⋄ →Exit⊣(rc msg)←⎕DMX.(EN(EM,' while creating client'))
     :EndTrap
     (rc msg)←0 'SMTPClient created'
 :EndIf

 :If ~0∊⍴messageArgs
     :If 0∊⍴server ⋄ →Exit⊣(rc msg)←¯1 'No SMTPClient defined' ⋄ :EndIf
     :Select ⎕NC⊂'messageArgs'
     :Case 2.1 ⋄ msgParams←⎕NS'' ⋄ msgParams.(To Subj Body)←'' '' ''{(≢⍺)↑⍵,⍺↓⍨≢⍵},⊆messageArgs
     :Case 9.1 ⋄ msgParams←messageArgs
     :Else ⋄ →Exit⊣(rc msg)←¯1 'Invalid messageArgs' ⍝ paranoia
     :EndSelect
     (rc msg log)←server.Send msgParams
 :EndIf
Exit:
