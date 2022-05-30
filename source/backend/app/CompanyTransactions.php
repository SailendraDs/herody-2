<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CompanyTransactions extends Model
{
    protected $table = "company_transactions";
    /**
     * Get the company that owns the CompanyTransactions
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function company(): BelongsTo
    {
        return $this->belongsTo(Employer::class, 'user_id');
    }
}
