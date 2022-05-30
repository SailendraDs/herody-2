@component('mail::message')
<div class="container">
    <div class="row">
        <div class="col-md-12">
            {!!$data['message']!!}
        </div>
    </div>
</div>

Thanks,<br>
{{ config('app.name') }}
@endcomponent
