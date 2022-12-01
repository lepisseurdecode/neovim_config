local endless_stream
endless_stream= function()
	return sn(nil, {
		c(1, {
			i(nil),
			sn(nil, {
				 t(' << '), i(1,'new param'), d(2, endless_stream, {})
				}
			),
			}
		)
	}
	)
end

local endless_param
endless_param= function()
	return sn(nil, {
		c(1, {
			i(nil),
			sn(nil, {
				 i(1,'param type'),t(' '), i(2, 'param name') ,t(', '), d(3, endless_param, {})
				}
			),
			}
		)
	}
	)
end

return {
		s('cout', {
			t('std::cout << '),
			d(1, endless_stream, {}),
			t(' << std::endl;'),
			}
		),
		s('fn',{
			i(1),
			t(' '),
			i(2),
			t('('),
			d(3, endless_param, {}),
			t('){'),
			i(4),
			t('}')
		})
}
