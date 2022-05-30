<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use App\CompletedGig;
use App\Gig;

class GigProofs implements FromView
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function __construct(int $id)
    {
        $this->id = $id;
        return $this;
    }
    public function view():View
    {
        $proofs = CompletedGig::where(['job_id' => $this->id])->get();
        
        return view('employer.gigs.allproofs', [
            'proofs' => $proofs,
            'id' =>$this->id,
        ]);
    }
}
