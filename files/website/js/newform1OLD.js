const form = document.getElementById('myForm');
    form.addEventListener('submit', async (event) => {
      event.preventDefault(); // Prevent the default form submission
      const formData = new FormData(form);
      const input = document.getElementById('emailnew');
      var Book =   {    "email" : input.value  };

      try {
        const response = await fetch('https://s81k08ktc2.execute-api.us-east-1.amazonaws.com/test/api', { // Replace '/submit-form' with your server endpoint
          method: 'PUT',
          headers: {'Content-Type': 'application/json: charset=UTF-8' },
          body: JSON.stringify(Book),
        });
        form.reset();
        if (response.ok) {
          // Form submission was successful, clear the form
          form.reset();
          alert('Form submitted successfully!');
        } else {
          // Handle errors
          console.error('Form submission failed:', response.status);
          alert('Form submission failed.');
        }
      } catch (error) {
        console.error('Error:', error);
        //alert('An error occurred during form submission.');
      }
    });
