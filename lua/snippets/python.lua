local endless_param 
endless_param= function()
	return sn(nil, {
		c(1, {
			i(nil),
			sn(nil, {
				 i(1,'new param'), t(', '), d(2, endless_param, {})
				}
			),
			}
		)
	}
	)
end

return {
		s('cl', {
			t('class '),
			i(1),
			t({':','\t'}),
			i(0)
			}
		),

		s('def', {
			t('def '),
			i(1),
			t('('),
			d(2, endless_param, {}),
			t(')'),
			c(3,{
				t(''),
				sn(nil,{t(' -> '), i(1)})
			}),
			t({':','\t'}),
			i(0)
			}
		),

		s('init', {
			t('def __init__ (self'),
			i(2),
			t({'):','\t'}),
			i(0)
			}
		),

		s('sf', {
			t('self.'),
			i(0)
		}
		)
 }
