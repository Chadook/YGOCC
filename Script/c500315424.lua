--Triple-Draguns of Gust Vine
function c500315424.initial_effect(c)
		   c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,160002427,aux.FilterBoolFunction(c500315424.ffilter),1,true,false)
		--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500315424,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c500315424.target)
	e1:SetOperation(c500315424.operation)
	c:RegisterEffect(e1)
end
function c500315424.filter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA 
end
function c500315424.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)  and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c500315424.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,c500315424.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
			local tc=g:GetFirst()
	if tc:IsType(TYPE_SYNCHRO+TYPE_XYZ) then Duel.SetChainLimit(c160009933.limit) end
end
function c160009933.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c500315424.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(math.ceil(atk/2))
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(math.ceil(atk/2))
			c:RegisterEffect(e2)
		end
	end
end

function c500315424.ffilter(c)
	return  c:GetLevel()==5 and (c:GetCode()~=500315424 and not c:IsCode(500315424))  and c:GetLevel()>0  or c:IsHasEffect(500317451)
end