@extends('layouts.app')
@section('title', config('app.name').' | Verify Email')
@section('content')
<div class="container">
    <div class="row">
        <div class="col-lg-12">
            <div class="account-popup-area signup-popup-box static">
                <div class="account-popup">
                    <h3>{{ __('Verify Your Email Address') }}</h3>
                    @if (session('resent'))
                        <div class="alert alert-success" role="alert">
                            {{ __('A fresh verification link has been sent to your email address.') }}
                        </div>
                    @endif
                    {{ __('Before proceeding, please check your email for a verification link.') }}
                    {{ __('If you did not receive the email') }},
                    <form class="d-inline" method="POST" action="{{ route('verification.resend') }}">
                        @csrf
                        <button type="submit" class="btn btn-link">{{ __('click here to request another') }}</button>.
                    </form>
                </div>
            </div><!-- SIGNUP POPUP -->
        </div>
    </div>
</div>
@endsection
