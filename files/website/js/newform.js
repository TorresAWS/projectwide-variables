const form = document.getElementById('myForm');

form.addEventListener('submit', function(event) {
  event.preventDefault();

  const formData = new FormData(form);
  
  const input = document.getElementById('emailnew');
  var Book =   {    "email" : input.value  };
                         
  fetch('https://693lblr4ve.execute-api.us-east-1.amazonaws.com/test/api', {
    method: 'PUT',
    headers: {'Content-Type': 'application/json: charset=UTF-8' },
    body: JSON.stringify(Book) 
  })
  .then(response => response.text())
//  .then(data => {
//    console.log('Success:', data);
//    alert('Form submitted successfully!');
//  })
//  .catch(error => {
//    console.error('Error:', error);
//    alert('An error occurred while submitting the form.');
//  });
});
