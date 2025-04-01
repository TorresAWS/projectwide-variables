var dtt = document.getElementById('txtbox')
dtt.onfocus = function (event) {
      this.type = 'datetime-local';
      this.focus();
};
const form = document.getElementById('myForm');
    form.addEventListener('submit', async (event) => {
      event.preventDefault(); 
      
//      var dtt = document.getElementById('txtbox')
//      dtt.onfocus = function (event) {
//         this.type = 'datetime-local';
//         this.focus();
//      }
      
      
      let children = event.target.querySelectorAll('input, textarea, select');
      let findEmpty = Array.from(children).find((element)=>{
          if(element.value.length < 1){return true}
          return false
      });
      if(findEmpty){
          alert(findEmpty.name);
      }else{
//          event.target.submit();
          const formData = new FormData(form);
          formData.toJSON = function() {
           const o = {};
           this.forEach((v, k) => {
             v = this.getAll(k);
             o[k] = v.length == 1 ? v[0] : (v.length >= 1 ? v : null);
           });
           return o;
          };
// it freezes the form and hides the button           
           const FORM_ELEMENTS = document.getElementById('myForm').elements;
           for (i = 0; i < FORM_ELEMENTS.length; i++) {
               FORM_ELEMENTS[i].disabled = true;
           }
           document.getElementById('submitButton').style.visibility='hidden';
           document.getElementById('myDIV').style.visibility='visible';
           var x = document.getElementById("myDIV");
           x.style.display = x.style.display != "block"?"block":"none"
          try {
            const response = await fetch('https://qtugeqfrt6.execute-api.us-east-1.amazonaws.com/test/api', { // Replace '/submit-form' with your server endpoint
              method: 'PUT',
              headers: {'Content-Type': 'application/json: charset=UTF-8' },
              body: JSON.stringify(formData),
            });
//            if (response.ok) {
//              // Form submission was successful, clear the form
//              alert('Form submitted successfully!');
//            } else {
//              form.reset();
//              console.error('Form submission failed:', response.status);
//              alert('Form submission failed.');
//            }
          } catch (error) {
            console.error('Error:', error);
            //alert('An error occurred during form submission.');
          } 
      }
    });
