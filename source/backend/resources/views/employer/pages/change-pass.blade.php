@extends('layouts.authApp')
@section('title',config('app.name').' | Change Password')
@section('content')
    <div class="container mt-3">
      <div class="row">
        <div class="col-sm-12 col-lg-8 col-xl-9">
          
          <div class="card">
            <div class="card-header">
              <div class="row align-items-center">
                <div class="col-8">
                  <h3 class="mb-0">Change Password </h3>
                </div>
                
              </div>
            </div>
            <div class="card-body">
              <form method="POST" action="{{route('employer.changepass')}}">
                  @csrf
                <div class="pl-lg-4">
                  <div class="row">
                    <div class="col-lg-12">
                      <div class="form-group">
                        <span class="form-control-label" for="opass">Current Password</span>
                        <input type="password" name="opass" class="form-control" placeholder="Current Password">
                      </div>
                    </div>
                    <div class="col-lg-6">
                      <div class="form-group">
                        <span class="form-control-label" for="password">New Password</span>
                        <input type="password" name="password" class="form-control" placeholder="New Password">
                      </div>
                    </div>
                    <div class="col-lg-6">
                      <div class="form-group">
                        <span class="form-control-label" for="repass">Repeat New Password</span>
                        <input type="password" name="repass" class="form-control" placeholder="Repeat New Password">
                      </div>
                    </div>
                  </div>
                </div>
                <button type="submit" class="btn btn-success">Change Password</button>
              </form>
            </div>
          </div>
        </div>
      </div>
      <!-- Footer -->
     
    </div>
@endsection