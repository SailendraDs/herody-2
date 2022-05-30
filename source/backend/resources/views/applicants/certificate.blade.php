@extends('layouts.app')
@section('title',config('app.name').' | '.$user->user_name.' profile')
@section("heads")
<link rel="stylesheet" href="{{asset('assets/applicant/css/style.css')}}">
<style>
html{
    height: 100%;
}
body{
    background: #F5FAF6;
    height: 100%;
}
</style>
@endsection
@section('content')
<div class="container certificate-area mt-3 mb-4">
    <div class="row">
        <div class="col-md-12">
            <img id="temp" src="{{asset('assets/certificate-template/coi.jpg')}}" alt="Cert" style="display:none;">
            <canvas id="cert"></canvas>
        </div>
    </div>
</div>
@endsection
@section('scripts')

<script>
var canvas = document.getElementById('cert'),
ctx = canvas.getContext('2d');
canvas.width = $('#temp').width();
canvas.crossOrigin = "Anonymous";
canvas.height = $('#temp').height();
ctx.drawImage($('#temp').get(0), 0, 0);
//redraw image
ctx.clearRect(0,0,canvas.width,canvas.height);
ctx.drawImage($('#temp').get(0), 0, 0,canvas.width,canvas.height);
//refill text
ctx.fillStyle = "#02022B";
ctx.font = "bold 50px Arial";
ctx.fillText("{{$user->name}}",400,355);
ctx.font = "bold 18px Arial";
ctx.fillText("{{$emp->name}}",690,447);
</script>

@endsection