+++
# Contact widget.
widget = "contact"
active = false
date = "2016-04-20T00:00:00"

title = "Contact"
subtitle = ""

# Order that this section will appear in.
weight = 100

# Automatically link email and phone?
autolink = false
+++

<form name="contact" method="POST" netlify>
  <div class="form-group">
    <label for="name">Your Name:</label>
    <input type="text" class="form-control" id="name" name="name" placeholder="Your Name:">
    <label for="email">Email Address</label>
    <input type="email" class="form-control" id="email" name="email" placeholder="Your E-Mail:">
    <label for="message">Message:</label>
    <textarea class="form-control" id="message" name="message" rows="3"></textarea>
    <button type="submit" class="btn btn-primary">Send</button>
  </div>
</form>
