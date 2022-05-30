@extends('layouts.app')
@section('title', config('app.name').' | Mobile not verified')
@section('content')
<section>
    <div class="block remove-bottom">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="account-popup-area signup-popup-box static">
                        <div class="account-popup">
                            <h3>{{ __('Verify Your Phone number') }}</h3>
                            {{ __('Before proceeding, please verify your phone number') }}
                            <a href="{{route('user.verify-mobile')}}" class="submit">{{ __('click here to request another') }}</a>.
                        </div>
                    </div><!-- SIGNUP POPUP -->
                </div>
            </div>
        </div>
    </div>
</section>
@endsection
