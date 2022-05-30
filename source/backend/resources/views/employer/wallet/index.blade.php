@extends('layouts.authApp')
@section('title',config('app.name').' | Wallet')
@section('content')
<section class="section mt-3">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-10">
				<div class="rounded shadow bg-white p-4">
					<div class="custom-form">
						<h2 id="message3">Wallet</h2>
                        <h5>Amount: {{$employer->wallet}}</h5>
                        <button class="btn btn-success btn-sm" data-toggle="modal" data-target="#add">Add Money</button>
					</div>
				</div>
				<div class="rounded shadow bg-white p-4 mt-2">
					<div class="custom-form">
						<h2 id="message3">Transactions</h2>
                        @if($transactions->count()===0)
                        <p>You haven't made any transaction yet.</p>
                        @else
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Transaction ID</th>
                                    <th>Amount</th>
                                    <th>Reason</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach ($transactions as $transaction)
                                    <tr>
                                        <td>{{$transaction->transaction_id}}</td>
                                        <td><span class="badge badge-{{$transaction->type==="INC"?"success":"danger"}}">{{$transaction->type==="INC"?"+":"-"}} {{$transaction->amount}} INR</span></td>
                                        <td>{{$transaction->reason}}</td>
                                        <td>{{\Carbon\Carbon::parse($transaction->created_at)->diffForHumans()}}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                        @endif
                        {{$transactions->links()}}
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

<div class="modal fade" id="add" tabindex="-1" role="dialog" aria-labelledby="add">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="addLabel">Add Money</h4>
            </div>
                <div class="modal-body">
                    <form action="{{route("employer.wallet.add")}}" method="post">
                        @csrf
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="amount">Amount</label>
                                    <input type="number" class="form-control" name="amount" placeholder="Amount">
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
@endsection