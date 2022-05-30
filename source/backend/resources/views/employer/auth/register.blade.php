@extends('layouts.app')
@section('title', config('app.name').' | For Companies')
@section('content')
<!-- Hero Start -->
<div class="home-center">
    <div class="home-desc-center">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="login_page bg-white shadow rounded p-4">
                        <div class="text-center">
                            <h4 class="mb-4">Company Register</h4>  
                        </div>
                        <form class="login-form" action="{{route('employer.register')}}" method="POST">
                            @csrf
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group position-relative">                                               
                                        <label>First name <span class="text-danger">*</span></label>
                                        <input name="fname" type="text" class="form-control" placeholder="First Name" />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group position-relative">                                               
                                        <label>Last name <span class="text-danger">*</span></label>
                                        <input name="lname" type="text" class="form-control" placeholder="Last Name" />
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-group position-relative">
                                        <label>Your Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" placeholder="Email" name="email" required="">
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-group position-relative">
                                        <label>Your Phone Number <span class="text-danger">*</span></label>
                                        <input name="phone" type="text" placeholder="Phone Number" class="form-control" />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group position-relative">
                                        <label>Password <span class="text-danger">*</span></label>
                                        <input name="password" type="password" placeholder="Password" class="form-control" />
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group position-relative">
                                        <label>Confirm Password <span class="text-danger">*</span></label>
                                        <input name="password_confirmation" type="password" placeholder="Confirm Password" class="form-control" />
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <div class="custom-control m-0 custom-checkbox">
                                            <input type="checkbox" class="custom-control-input" id="customCheck1">
                                            <label class="custom-control-label" for="customCheck1">I Accept <a href="#" class="text-primary">Terms And Condition</a></label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <button class="btn btn-primary w-100">Register</button>
                                </div>
                                <div class="mx-auto">
                                    <p class="mb-0 mt-3"><small class="text-dark mr-2">Already have an account ?</small> <a href="{{ route('employer.login') }}" class="text-dark font-weight-bold">Sign in</a></p>
                                </div>
                            </div>
                        </form>
                    </div>
                </div> <!--end col-->
            </div><!--end row-->
        </div> <!--end container-->
    </div>
</div>
<!-- Hero End -->
@endsection