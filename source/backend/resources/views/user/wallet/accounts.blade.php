@extends('layouts.authApp')
@section('title',config('app.name').' | Accounts')
@section('content')
<section class="section">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-10">
				<div class="">
					<div class="custom-form page-head">
						<h2 id="message3">Accounts</h2>
					</div>
				</div>
				<div class="rounded shadow bg-white p-4 mt-2">
					<div class="custom-form">
                        <div class="row">
                            <div class="col-md-6 col-sm-12 mb-3">
                                @if($user->bank_acc_id===NULL)
                                <button class="btn btn-success" data-toggle="modal" data-target="#bank">Add a bank account</button>
                                @else
                                <div class="card rounded">
                                    <div class="card-header">
                                        <h4 class="card-title">Bank Account</h4>
                                    </div>
                                    <div class="card-body">
                                        <p>Account Holder's Name: {{$user->bank_acc_id->name}}</p>
                                        <p>Account Number: {{$user->bank_acc_id->account_no}}</p>
                                        <p>IFSC Code: {{$user->bank_acc_id->ifsc}}</p>
                                    </div>
                                </div>
                                @endif
                            </div>
                            <div class="col-md-6 col-sm-12 mb-3">
                                @if($user->upi_acc_id===NULL)
                                <button class="btn btn-success" data-toggle="modal" data-target="#upi">Add an UPI account</button>
                                @else
                                <div class="card rounded">
                                    <div class="card-header">
                                        <h4 class="card-title">UPI Account</h4>
                                    </div>
                                    <div class="card-body">
                                        <p>UPI ID: {{$user->upi_acc_id->upi}}</p>
                                    </div>
                                </div>
                                @endif
                            </div>
                        </div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
@if($user->bank_acc_id===NULL)
<div class="modal fade" id="bank" tabindex="-1" role="dialog" aria-labelledby="bank">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="bankLabel">Add a bank account</h4>
            </div>
                <div class="modal-body">
                    <form action="{{route("user.wallet.addBank")}}" method="post">
                        @csrf
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="name">Account holder name</label>
                                    <input type="text" class="form-control" name="name">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="acc_no">Account number</label>
                                    <input type="text" class="form-control" name="acc_no">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="ifsc">Bank IFSC Code</label>
                                    <input type="text" class="form-control" name="ifsc">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <button class="btn btn-primary">Add</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endif
@if($user->upi_acc_id===NULL)
<div class="modal fade" id="upi" tabindex="-1" role="dialog" aria-labelledby="upi">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="bankLabel">Add an UPI account</h4>
            </div>
                <div class="modal-body">
                    <form action="{{route("user.wallet.addUpi")}}" method="post">
                        @csrf
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="upi">UPI ID</label>
                                    <input type="text" class="form-control" name="upi">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <button class="btn btn-primary">Add</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endif
@endsection