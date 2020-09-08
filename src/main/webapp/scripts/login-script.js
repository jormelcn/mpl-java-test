const loginForm = document.getElementById("login-form");
const loginLoading = document.getElementById("login-loading");
const loginButton = document.getElementById("login-button");
const loginFieldset = document.getElementById("login-fieldset");
const loginErrorMessage = document.getElementById("login-error-message"); 
const loginNameInput = document.getElementById("login-name-input");
const loginPassInput = document.getElementById("login-pass-input");


function verifyLoginName(){
	if(loginNameInput.value.trim().length > 0)
		return true;
	else
		return false;
}

function verifyLoginPass(){
	if(loginPassInput.value.trim().length > 0)
		return true;
	else
		return false;
}

loginButton.addEventListener("click", event => {
	if(verifyLoginName() && verifyLoginPass()){
		loginLoading.className = "lds-ellipsis";
		loginErrorMessage.innerHTML = "";
		loginButton.disabled = true;
		setTimeout(()=>{
			loginForm.submit();
		}, 1000);
	} else {
		if(!verifyLoginName())
			loginNameInput.className = "error";
		if(!verifyLoginPass())
			loginPassInput.className = "error";
		loginErrorMessage.innerHTML = "Verifique los campos marcados en rojo";
		loginLoading.className = "hidden-lds-ellipsis";
	}
});

loginNameInput.addEventListener("change", event => {
	if(verifyLoginName())
		loginNameInput.className = "";
	else
		loginNameInput.className = "error";
});

loginPassInput.addEventListener("change", event => {
	if(verifyLoginPass())
		loginPassInput.className = "";
	else
		loginPassInput.className = "error";
});

