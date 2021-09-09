 (rc msg client log)←clientArgs SendMail messageArgs;⎕ML;⎕IO;params;msgParams;log
 ⍝ Simple cover to send SMTP mail
 ⍝ Requires: SMTP class

 ⍝ Version 1.1 2021-09-09

 ⍝ rc     - return code; 0=no error, 1=error from the SMTP server, anything else=other error
 ⍝ msg    - descriptive message
 ⍝ client - reference to instance of SMTP (only returned when clientArgs is the server definition)
 ⍝ log    - log of server responses


 ⍝ clientArgs is one of:
 ⍝ A client definition in one of the following formats:
 ⍝   ∘ a vector of Server Port From [Password [Userid [Secure]]]
 ⍝   ∘ a namespace containing required named elements: Server Port From
 ⍝     and optionally Password Userid Secure plus any other parameters applicable to the SMTP class
 ⍝   where
 ⍝     Server   - address of the SMTP server
 ⍝     Port     - port for the SMTP server
 ⍝     From     - "from" email address; if Userid is not specified From is also used for authentication if necessary
 ⍝     Password - password to access the SMTP server
 ⍝     Userid   - userid for authentication; not needed if it's the same as From
 ⍝     Secure   - Boolean indicating whether to use SSL/TLS; if not specified Secure will be inferred from the Port
 ⍝ Or
 ⍝   ∘ an instance of the SMTP class created by SendMail

 ⍝ messageArgs is one of:
 ⍝ ∘ a vector of To Subj Body
 ⍝ ∘ a namespace containing required named elements: To Subj Body
 ⍝     and optionally any other parameters applicable to the SMTP.Message class

 ⍝ Once the SMTP client instance has been created, it can be passed as the left argument
 ⍝ in subsequent calls to Sendmail

 ⍝ Examples:
 ⍝ (clt←⎕NS'').(Server Port From Password)←'mail.abc.com' 465 'me@abc.com' 'secret'
 ⍝ Client←3⊃clt SendMail '' ⍝ create the client instance
 ⍝ (msg←⎕NS'').(To Subj Body)←'you@xyz.com' 'Hello' 'Hi there!'
 ⍝ Client SendMail msg      ⍝ client instance is the left argument here
 ⍝
 ⍝ The client instance can be created and message sent in a single call:
 ⍝ Client←3⊃clt SendMail msg

 ⎕IO←⎕ML←1

 (rc msg client log)←¯1 'Nothing done' '' ''
 params←0
 :Select ⎕NC⊂'clientArgs'
 :Case 2.1 ⋄ params←⎕NS'' ⋄ params.(Server Port From Password Userid Secure)←''⍬'' '' '' ¯1{(≢⍺)↑⍵,⍺↓⍨≢⍵},⊆clientArgs
 :Case 9.1 ⋄ params←clientArgs
 :Case 9.2 ⋄ client←clientArgs
 :Case 0 ⍝ not defined? do nothing
 :Else ⋄ →Exit⊣(rc msg)←¯1 'Invalid clientArgs' ⍝ paranoia
 :EndSelect

 :If params≢0
     :Trap 0 ⋄ client←⎕NEW SMTP params
     :Else ⋄ →Exit⊣(rc msg)←⎕DMX.(EN(EM,' while creating client'))
     :EndTrap
     (rc msg)←0 'SMTPClient created'
 :EndIf

 :If ~0∊⍴messageArgs
     :If 0∊⍴client ⋄ →Exit⊣(rc msg)←¯1 'No SMTPClient defined' ⋄ :EndIf
     :Select ⎕NC⊂'messageArgs'
     :Case 2.1 ⋄ msgParams←⎕NS'' ⋄ msgParams.(To Subj Body)←'' '' ''{(≢⍺)↑⍵,⍺↓⍨≢⍵},⊆messageArgs
     :Case 9.1 ⋄ msgParams←messageArgs
     :Else ⋄ →Exit⊣(rc msg)←¯1 'Invalid messageArgs' ⍝ paranoia
     :EndSelect
     (rc msg log)←client.Send msgParams
 :EndIf
Exit:
