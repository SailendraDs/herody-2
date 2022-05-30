@component('mail::message')
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <p>Dear {{$data['user']}}</p>
            <p>We congratulate you on your selection in the job <strong>{{$data['job']}}</strong>. Please view your certificate by clicking on the button below.</p>
        </div>
    </div>
</div>

<center><a href="{{route('certificate.print',[$data['jid'],$data['uid']])}}" class="btn btn-primary">Download Resume</a></center>

Thanks,<br>
{{ config('app.name') }}
@endcomponent
