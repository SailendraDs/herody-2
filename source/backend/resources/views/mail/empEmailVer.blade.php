@component('mail::message')
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <p>Dear {{$data['user']}}</p>
            <p>Welcome to {{config('app.name')}}. Please enter the OTP to verify your email.</p>
        </div>
    </div>
</div>

<h1 class="text-muted">{{$data['otp']}}</h1>

Thanks,<br>
{{ config('app.name') }}
@endcomponent
