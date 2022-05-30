@extends('layouts.app')
@section('title', config('app.name').' | Reset Password')
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
                                <h4 class="mb-4">Reset Password</h4>  
                            </div>
                            <form class="login-form" action="{{ route('password.update') }}" method="POST">
                                @csrf
                                <div class="row">
                                    <div class="col-lg-12">
                                        <div class="form-group position-relative">
                                            <label>Your Email <span class="text-danger">*</span></label>
                                            <input name="email" type="email" placeholder="Email" class="form-control" required />
                                        </div>
                                    </div>

                                    <div class="col-lg-12">
                                        <div class="form-group position-relative">
                                            <label>New Password <span class="text-danger">*</span></label>
                                            <input name="password" type="password" placeholder="New Password" class="form-control" required />
                                        </div>
                                    </div>

                                    <div class="col-lg-12">
                                        <div class="form-group position-relative">
                                            <label>Confirm new password <span class="text-danger">*</span></label>
                                            <input name="password_confirmation" type="password" placeholder="Confirm new password" class="form-control" required />
                                        </div>
                                    </div>
                                    <div class="col-lg-12 mb-0">
                                        <button class="btn btn-primary w-100">Reset Password</button>
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
