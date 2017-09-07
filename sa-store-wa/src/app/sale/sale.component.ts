import { Component, OnInit } from '@angular/core';
import { SaleService } from '../sale.service';
import { Http, Request, RequestMethod, RequestOptions, Headers } from '@angular/http';

@Component({
  selector: 'app-sale',
  templateUrl: './sale.component.html',
  styleUrls: ['./sale.component.css']
})
export class SaleComponent implements OnInit {

  constructor(
    private saleService: SaleService,
    private http: Http
  ) { }

  ngOnInit() {
  }

  buyProduct(user_id, product_id) {
    this.saleService.buyProduct(user_id, product_id).subscribe(res => {
      console.log(res)
    })
  }

}
