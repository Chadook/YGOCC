--Yasmin, Young Princess of Gust Vine
function c160009933.initial_effect(c)
		   c:EnableReviveLimit()
		aux.AddFusionProcCodeFun(c,500315980,aux.FilterBoolFunction(c160009933.ffilter),1,true,false)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160009933,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,160009933)
	e1:SetCondition(c160009933.condition)
	e1:SetTarget(c160009933.target)
	e1:SetOperation(c160009933.operation)
	c:RegisterEffect(e1)
		--leave field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c160009933.operation2)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)

end
function c160009933.ffilter(c)
	return  c:GetLevel()<=4 and c:GetCode()~=160009933 and not c:IsCode(160009933)  and c:GetLevel()>0  or c:IsHasEffect(500317451)
end
function c160009933.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c160009933.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsFacedown() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(160009933,0))
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetChainLimit(c160009933.limit(g:GetFirst()))
end
function c160009933.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c160009933.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
			c:SetCardTarget(tc)
			e:GetLabelObject():SetLabelObject(tc)
		c:CreateRelation(tc,RESET_EVENT+0x5020000)
		tc:CreateRelation(c,RESET_EVENT+0x1fe0000)
		--local e1=Effect.CreateEffect(c)
		--e1:SetType(EFFECT_TYPE_SINGLE)
		--e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		--e1:SetCode(EFFECT_CANNOT_TRIGGER)
		--e1:SetReset(RESET_EVENT+0x1fe0000)
		--e1:SetCondition(c160009933.rcon)
		--e1:SetValue(1)
		--tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
end
end
function c160009933.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end

function c160009933.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc and c:IsRelateToCard(tc) and tc:IsRelateToCard(c) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
