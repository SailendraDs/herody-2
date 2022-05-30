@extends('layouts.app')
@section('title', config('app.name').' | Verify Mobile')
@section('content')
<section>
    <div class="block remove-bottom">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="account-popup-area signup-popup-box static">
                        <div class="account-popup">
                            <h3>{{ __('Verify Your Phone number') }}</h3>
                            <form action="{{route('user.verify-mobilep')}}" method="post">
                                @csrf
                                <input type="hidden" name="otpv" value="{{$otpv}}">
                                <div class="form-group col-md-12">
                                    <div for="otp">Enter otp</div>
                                    <input type="text" name="otp" class="form-control">
                                </div>
                                <button type="submit" class="btn btn-primary">Submit</button>
                            </form>
                        </div>
                    </div><!-- SIGNUP POPUP -->
                </div>
            </div>
        </div>
    </div>
</section>
@endsection
