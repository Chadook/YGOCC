--Fantasia Shield
function c71473123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c71473123.con)
	e1:SetTarget(c71473123.tg)
	e1:SetOperation(c71473123.act)
	c:RegisterEffect(e1)
end
function c71473123.con(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c71473123.target)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_SPELL+TYPE_TRAP)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	return tc:IsOnField() and tc:IsSetCard(0x1C1D) and tc:IsControler(tp)
end
function c71473123.target(e,c)
	return c:IsSetCard(0x1C1D)
end
function c71473123.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return c:IsSetCard(0x1C1D) and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c71473123.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc~=e:GetLabelObject() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71473123.filter,tp,LOCATION_MZONE,0,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c71473123.filter,tp,LOCATION_MZONE,0,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c71473123.act(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g and g:GetFirst():IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,g)
	end
end