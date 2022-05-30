@extends('layouts.app')
@section('title',config('app.name').' | Enter OTP')

@section('content')
<!-- Hero Start -->
<section>
    <div class="home-center">
        <div class="home-desc-center">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-4 col-md-6">
                        <div class="login-page bg-white shadow rounded p-4">
                            <div class="text-center">
                                <h4 class="mb-4">Enter OTP</h4>  
                            </div>
                            <form class="login-form" action="{{route('employer.verify.emailr')}}" method="POST">
                                @csrf
                                <div class="row">
                                    <div class="col-lg-12">
                                        <p class="text-muted">An OTP has been sent to your email address.</p>
                                        <div class="form-group position-relative">
                                            <label>Enter OTP <span class="text-danger">*</span></label>
                                            <input type="text" name="otp" placeholder="OTP" class="form-control" required/>
                                        </div>
                                    </div>
                                    <input type="hidden" name="otpv" value="{{$otp}}">

                                    <div class="col-lg-12">
                                        <p class="float-right forgot-pass"><a href="{{route('employer.verify.email')}}" class="text-dark font-weight-bold">Resend Code</a></p>
                                    </div>
                                    <div class="col-lg-12 mb-0">
                                        <button class="btn btn-primary w-100">Verify</button>
                                    </div>
                                </div>
                            </form>
                        </div><!---->
                    </div> <!--end col-->
                </div><!--end row-->
            </div> <!--end container-->
        </div>
    </div>
</section><!--end section-->
<!-- Hero End -->
@endsection