@extends('layouts.app')
@section('title', config('app.name').' | Login')
@section('heads')
    <style type="text/css">
  .mobileShow {display: none;}

  /* Smartphone Portrait and Landscape */
  @media only screen and (min-device-width : 320px) and (max-device-width : 480px){ 
      .mobileShow {display: inline;}
  }
</style>
@endsection
@section('content')
<!-- Mirrored from Viti2 -->

<section>
    <div class="block no-padding  gray">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="inner2">
                        <div class="inner-title2">
                            <h3>User</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section>
    <div class="block remove-bottom">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="account-popup-area signup-popup-box static">
                        <div class="account-popup">
                            <h3>Account Details</h3>
                            <form method="post" action="" >
                                @csrf
                                
                                <div class="form-group">
                                    <label for="mcq">Account Type</label>
                                    <select name="acc_type" id="mcq" class="form-control">
                                    <option value="">Choose..</option>
                                    <option value="bank_account">Bank Account</option>
                                    <option value="vpa">UPI</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                  <label for="formGroupExampleInput">IFSC</label>
                                  <input type="text" class="form-control" id="ifsc" name="ifsc" placeholder="IFSC code" disabled>
                                </div>
                                <div class="form-group">
                                  <label for="opt1">Account number</label>
                                  <input type="text" class="form-control" id="acc_no" name="acc_no" placeholder="Account Number" disabled="disabled">
                                </div>
                                <div class="form-group">
                                    <label for="opt2">UPI ID</label>
                                    <input type="text" class="form-control" id="vpa" name="vpa" placeholder="UPI ID" disabled="disabled">
                                </div>
                                
                                <button class="btn btn-block btn-outline-success" type="submit" name="submit">Submit</button>
                            </form>
                            
                        </div>
                    </div><!-- SIGNUP POPUP -->
                </div>
            </div>
        </div>
    </div>
</section>
@endsection

@section('scripts')
<script>
    document.getElementById('mcq').onchange=function(){
        if(this.value=='bank_account')
        {
            document.getElementById('ifsc').disabled=false;
            document.getElementById('acc_no').disabled=false;
            document.getElementById('vpa').disabled=true;
           
        }
        else
        {
            document.getElementById('ifsc').disabled=true;
            document.getElementById('acc_no').disabled=true;
            document.getElementById('vpa').disabled=false;

        }
    }
    </script>
<script>
    function logint(){
        window.location = "truecallersdk://truesdk/web_verify?requestNonce=14523678&partnerKey=SELIu8fd241fbfbd34429a4ed17e79d6bea4f&partnerName=Herody&lang=en&title=Login";

        setTimeout(function() {

        if( document.hasFocus() ){
            alert('You do not have truecaller app installed on your device');
        }
        else{
            
            }
        }, 600);
    }
</script>
@endsection