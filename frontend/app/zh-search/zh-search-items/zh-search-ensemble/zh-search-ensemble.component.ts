import { Component, OnInit, Input } from '@angular/core';
import { FormGroup } from '@angular/forms';

@Component({
  selector: 'zh-search-ensemble',
  templateUrl: './zh-search-ensemble.component.html',
  styleUrls: ['./zh-search-ensemble.component.scss'],
})
export class ZhSearchEnsembleComponent implements OnInit {
  @Input() data: any;
  @Input() form: FormGroup;
  constructor() {}

  ngOnInit() {
  }
}
